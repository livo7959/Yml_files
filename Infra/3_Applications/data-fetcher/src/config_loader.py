import os
from typing import Dict
import yaml

ENV = os.environ.get('ENVIRONMENT')

def load_config(config_path: str, passed_data: Dict) -> Dict:
  operation = passed_data.get('operation')
  with open(f'{config_path}/{passed_data["source"]}.yaml', 'rb') as config_file:
    contents = yaml.safe_load(config_file)
  contents['source'] = passed_data['source']
  contents['env'] = ENV
  operation_config = contents.pop('operations').get(operation)
  _get_client_config(contents, client_name=passed_data.get('client_name'))
  return {**contents, **operation_config}

def _get_client_config(contents: Dict, client_name: str) -> Dict:
  env_contents = contents.pop('envs', {}).get(ENV, {})
  if client_name:
    env_contents = env_contents.get(client_name, {})

  contents.update(env_contents)
