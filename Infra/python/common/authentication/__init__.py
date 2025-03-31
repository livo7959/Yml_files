from abc import ABC, abstractmethod
from requests.auth import HTTPBasicAuth
from typing import Dict

from utils import TokenGetter

class AuthClient(ABC):
  """
  Abstract base class for an API client with different authentication methods.
  """
  @abstractmethod
  def auth_header(self) -> Dict[str, str]:
    """Abstract method to get authentication header if it exists."""
    pass

  @abstractmethod
  def request_auth(self):
    """Abstract method to get authentication to attach to request."""
    pass

class NoAuthClient(AuthClient):
  def auth_header(self) -> Dict[str, str]:
    return {}

  def request_auth(self):
    return

class BearerTokenClient(AuthClient):
  def __init__(self, token):
    super().__init__()
    self.token = token

  def auth_header(self) -> Dict[str, str]:
    return {'Authorization': f'Bearer {self.token}'}

  def request_auth(self):
    return

class BasicAuthClient(AuthClient):
  def __init__(self, username, password):
    super().__init__()
    self.username = username
    self.password = password

  def auth_header(self) -> Dict[str, str]:
    return {}

  def request_auth(self):
    return HTTPBasicAuth(self.username, self.password)

class StaticTokenClient(AuthClient):
  def __init__(self, token, header_key):
    super().__init__()
    self.token = token
    self.header_key = header_key

  def auth_header(self) -> Dict[str, str]:
    return {self.header_key: self.token}

  def request_auth(self):
    return

class Authenticator:
  def __init__(self, config: Dict, token_getter: TokenGetter) -> None:
    self.auth_type = config['auth_type']
    self.token_getter = token_getter

    if self.auth_type == 'bearer_token':
      token = config.get('api_key', token_getter.get_token())
      self.auth_client = BearerTokenClient(token)
    elif self.auth_type == 'static_token':
      token = config.get('api_key', token_getter.get_token())
      self.auth_client = StaticTokenClient(token, config['header_key'])
    elif self.auth_type == 'basic_auth':
      username = config.get('username')
      password = config.get('password')
      self.auth_client = BasicAuthClient(username, password)
    else:
      self.auth_client = NoAuthClient()

  def auth_header(self) -> Dict[str, str]:
    return self.auth_client.auth_header()

  def request_auth(self):
    return self.auth_client.request_auth()
