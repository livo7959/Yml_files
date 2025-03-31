import logging
import requests
from uuid import uuid4

class Requester:
  def __init__(self, *, validate_request: bool = True) -> None:
    self.validate_request = validate_request
    self._class_id = uuid4()

  def request(self, method, url, timeout=60, **kwargs) -> requests.Response:
    request_id = str(uuid4())
    logging.info('Making %s request to %s. request_id: %s', method, url, request_id)
    response = requests.request(method, url, timeout=timeout, **kwargs)
    if self.validate_request:
      response.raise_for_status()
    return response
