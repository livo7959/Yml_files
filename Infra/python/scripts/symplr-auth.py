import argparse
from datetime import datetime, timezone
from typing import Dict, List

import requests
import yaml

from az_key_vault import AzureKeyVault

def handler(env: str, auth_config: Dict[str, str]):
  vault_url = get_vault_url(env)
  access_token, _, expire_timestamp = get_token(
    vault_url,
    auth_config['auth_url'],
    auth_config['client_id'],
    auth_config['client_key']
  )
  save_bearer_token_to_vault(
    vault_url,
    access_token,
    auth_config['secret_name'],
    int(expire_timestamp)
  )

def get_vault_url(env: str):
  return f'https://lh-azkv-{env}.vault.azure.net/'

def run(env: str):
  with open('./configs/api-auth/symplr.yaml', 'rb') as config_file:
    contents = yaml.safe_load(config_file)

  for auth_config in contents[env]:
    handler(env, auth_config)

def save_bearer_token_to_vault(vault_url: str, access_token: str, secret_name: str, expire_timestamp: int) -> None:
  akv_client = AzureKeyVault(vault_url)
  akv_client.set_secret(secret_name, access_token, expires_on=datetime.fromtimestamp(expire_timestamp, timezone.utc))

def get_token(vault_url: str, auth_url: str, client_id: str, client_key: str) -> List[str]:
  akv_client = AzureKeyVault(vault_url)

  client_id_value = akv_client.get_secret_value(client_id)
  client_key_value = akv_client.get_secret_value(client_key)

  headers = {
    'clientId': client_id_value,
    'clientKey': client_key_value,
    'userid': client_id_value,
    'datasource': 'logixhealth'
  }
  response = requests.post(auth_url, headers=headers, timeout=30)

  if response.status_code == 200:
    return response.text.replace('"', '').split(':')

  raise RuntimeError('AccessToken not found')

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Get Access Token for Symplr API')
  parser.add_argument('--env', type=str, choices=['sbox', 'stg', 'prod'], help='target environment', required=True)
  args = parser.parse_args()

  run(args.env)
