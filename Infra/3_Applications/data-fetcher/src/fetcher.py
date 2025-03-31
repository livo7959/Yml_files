from abc import ABC, abstractmethod
from datetime import datetime, timezone
import json
import logging
import operator
import os
from requests import Response
import tempfile
from typing import Dict
import zipfile

import jmespath

from authentication import Authenticator
from az_key_vault import AzureKeyVault
from az_service_bus import AzureServiceBus
from az_storage import AzureStorage
from requester import Requester
from utils import TokenGetter

ENV = os.getenv("ENVIRONMENT")
OPERATOR_SINGLE_OPS = [
  'not',
  'truth'
]

class AzTokenGetter(TokenGetter):
  _instances = {}

  def __new__(cls, token_name: str):
    if token_name not in cls._instances:
      cls._instances[token_name] = super(AzTokenGetter, cls).__new__(cls)
    return cls._instances[token_name]

  def __init__(self, token_name: str):
    if not hasattr(self, 'initialized'):
      self.token_name = token_name
      self.akv_client = AzureKeyVault(f'https://lh-azkv-{ENV}.vault.azure.net/')
      self.initialized = True

  def get_token(self) -> str:
    return self.akv_client.get_secret_value(self.token_name)

class ResponseHandler():
  def __init__(self, response: Response, config: Dict, passed_data: Dict, service_bus_host_name: str, service_bus_queue_name: str):
    self.response = response
    self.passed_data = passed_data
    self.config = config
    self.service_bus = AzureServiceBus(service_bus_host_name)
    self.service_bus_queue_name = service_bus_queue_name

class TypedResponseHandler(ABC):
  """
  Abstract base class for an API client with different authentication methods.
  """
  def __init__(self, response_handler: ResponseHandler):
    self.response = response_handler.response
    self.passed_data = response_handler.passed_data
    self.config = response_handler.config
    self.service_bus = response_handler.service_bus
    self.service_bus_queue_name = response_handler.service_bus_queue_name

  @abstractmethod
  def run(self):
    pass

class JsonResponseHandler(TypedResponseHandler):
  def __init__(self, response_handler: ResponseHandler):
    super().__init__(response_handler)
    self.json_response = json.loads(self.response.text)

  def run(self):
    self._parse_data()
    self._handle_adls2_destinations()
    self._handle_pagination()
    self._handle_chained_requests()
    return self.json_response

  def _parse_data(self):
    for key_name, parse_path in self.config.get('data_parsing', {}).items():
      self.passed_data[key_name] = jmespath.search(parse_path, self.json_response)

  def _handle_adls2_destinations(self) -> None:
    adls2_dest_config = self.config.get('destination', {}).get('adls2')
    if not adls2_dest_config:
      return

    # add timestamp & Y/M/D folder paths to destination path
    timestamp = datetime.now(timezone.utc)
    file_name_date_path = f'{timestamp.year}/{timestamp.month}/{timestamp.day}'
    file_name_parts = adls2_dest_config['filename'].split('/')
    file_name = os.path.join(*file_name_parts[:-1],file_name_date_path, file_name_parts[-1])

    storage_client = AzureStorage(f'{adls2_dest_config['storage_account']}{ENV}')
    storage_client.upload_data_to_filename(
      adls2_dest_config['storage_container'],
      f'{file_name}_{timestamp.isoformat()}.json'.format(**self.passed_data),
      self.response.text
    )

  def _handle_chained_requests(self):
    messages_to_send = []
    for chained_request in self.config.get('chained_requests', []):
      if for_each := chained_request.pop('for_each', None):
        for item in jmespath.search(for_each['data_path'], self.json_response):
          self.passed_data[for_each['data_key']] = item
          chained_request = populate_templated_variables(chained_request, self.passed_data)
          messages_to_send.append(json.dumps({**self.passed_data, **chained_request}))
      else:
        messages_to_send.append(json.dumps({**self.passed_data, **chained_request}))

    if messages_to_send:
      self.service_bus.send_messages_to_queue(self.service_bus_queue_name, messages_to_send)

  def _handle_pagination(self):
    pagination = self.config.get('pagination')
    if not pagination:
      return

    continue_pagination = True
    # check if pagination should continue
    if 'data_check' in pagination:
      data_check = pagination['data_check']
      check_value = jmespath.search(data_check['data_path'], self.json_response)
      op = data_check['op']

      if op in OPERATOR_SINGLE_OPS:
        continue_pagination = getattr(operator, op)(check_value)
      else:
        if 'compare_value' in data_check:
          compare_value = data_check.get('compare_value')
        else:
          compare_value = jmespath.search(data_check.get('compare_key'), self.json_response)

        compare_value = compare_value.format(**self.passed_data) if isinstance(compare_value, str) else compare_value
        continue_pagination = getattr(operator, op)(check_value, compare_value)

    if continue_pagination:
      pagination_type = pagination['type']
      if pagination_type == 'offset_limit':
        self.passed_data['offset'] = self.passed_data['offset'] + self.passed_data['limit']
      elif pagination_type == 'next_page':
        self.passed_data[pagination['next_page_key']] += 1
      self.service_bus.send_message_to_queue(
        self.service_bus_queue_name,
        json.dumps({**self.passed_data})
      )

class ZipResponseHandler(TypedResponseHandler):
  def __init__(self, response_handler: ResponseHandler):
    super().__init__(response_handler)

  def run(self):
    adls2_dest_config = self.config.get('destination', {}).get('adls2')
    storage_client = AzureStorage(f'{adls2_dest_config['storage_account']}{ENV}')

    with tempfile.TemporaryDirectory() as tmpdir:
      zip_path = os.path.join(tmpdir, 'temp.zip')

      # Save the downloaded content to a ZIP file
      with open(zip_path, 'wb') as f:
        f.write(self.response.content)

      logging.info(f'Downloaded ZIP file to {zip_path}')

      # Extract the ZIP file
      with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(tmpdir)
        extracted_files = zip_ref.namelist()

      logging.info(f"Extracted files: {extracted_files}")

      for file_name in extracted_files:
        with open(os.path.join(tmpdir, file_name), 'rb') as file:
          # add timestamp & Y/M/D folder paths to destination path
          timestamp = datetime.now(timezone.utc)
          file_name_date_path = f'{timestamp.year}/{timestamp.month}/{timestamp.day}'
          file_path = os.path.join(adls2_dest_config['filename'], file_name_date_path)

          storage_client.upload_data_to_filename(
            adls2_dest_config['storage_container'],
            f'{file_path}/{file_name}'.format(**self.passed_data),
            file
          )

def populate_templated_variables(obj: Dict, replacements: Dict) -> Dict:
  for k, v in obj.items():
    if isinstance(v, str):
      obj[k] = v.format(**replacements)
    elif isinstance(v, dict):
      obj[k] = populate_templated_variables(v, replacements)
  return obj

class Fetcher:
  def __init__(self, config: Dict, passed_data: Dict, service_bus_host_name: str, service_bus_queue_name: str) -> None:
    self.passed_data = passed_data
    self.config = config
    self.service_bus_host_name = service_bus_host_name
    self.service_bus_queue_name = service_bus_queue_name
    self.authenticator = Authenticator(config, AzTokenGetter(self.config.get('access_token_key')))
    self.requester = Requester()

  def run(self):
    response = self.requester.request(
      self.config.get('request_type', 'GET'),
      self._build_url(),
      headers={**self.authenticator.auth_header(), **self.config.get('request_headers', {})},
      auth=self.authenticator.request_auth(),
      data=populate_templated_variables(self.config.get('request_data', {}), self.passed_data),
      json=populate_templated_variables(self.config.get('request_json', {}), self.passed_data)
    )

    response_type = self.config.get('response_type', 'json')
    response_handler = ResponseHandler(response, self.config, self.passed_data, self.service_bus_host_name, self.service_bus_queue_name)

    if response_type == 'json':
      response_handler = JsonResponseHandler(response_handler).run()
    elif response_type == 'zip':
      response_handler = ZipResponseHandler(response_handler).run()
    else:
      raise RuntimeError(f'Invalid response_type {response_type}')

  def _build_url(self):
    if 'url' in self.passed_data:
      return self.passed_data['url']
    return f'{self.config["base_url"]}{self.config["endpoint"]}'.format(**self.passed_data)
