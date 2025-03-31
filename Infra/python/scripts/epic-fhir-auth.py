import argparse
import base64
from datetime import datetime, timezone, timedelta
from hashlib import sha256, sha384
import json
from typing import Dict
from uuid import uuid4

import requests
import yaml

from az_key_vault import AzureKeyVault

def handler(env: str, auth_config: Dict[str, str]):
  vault_url = get_vault_url(env)
  access_token = get_bearer_token(
    vault_url,
    auth_config['client_id'],
    auth_config['auth_url'],
    auth_config['key_name']
  )
  save_bearer_token_to_vault(vault_url, access_token, auth_config['secret_name'])

def get_vault_url(env: str):
  return f'https://lh-azkv-{env}.vault.azure.net/'

def run(env: str):
  with open('./configs/api-auth/epic-fhir.yaml', 'rb') as config_file:
    contents = yaml.safe_load(config_file)

  for auth_config in contents[env]:
    handler(env, auth_config)

def encode_payload(payload) -> str:
  return base64.urlsafe_b64encode(payload).decode().rstrip('=')

def save_bearer_token_to_vault(vault_url: str, access_token: str, secret_name: str) -> None:
  akv_client = AzureKeyVault(vault_url)
  akv_client.set_secret(secret_name, access_token, expires_on=datetime.now(tz=timezone.utc) + timedelta(seconds=3600))

def get_bearer_token(vault_url: str, client_id: str, auth_url: str, key_name: str) -> str:
  akv_client = AzureKeyVault(vault_url)

  jwt_header = {
    'alg': 'ES384',
    'typ': 'JWT',
    'kid': str(sha256(akv_client.get_key(key_name).id.encode()).hexdigest())
  }

  jwt_payload = {
    'iss': client_id,
    'sub': client_id,
    'aud': auth_url,
    'jti': str(uuid4()),
    'exp': int((datetime.now(tz=timezone.utc) + timedelta(minutes=5)).timestamp())
  }

  # Encode header and payload to base64
  header_encoded = encode_payload(json.dumps(jwt_header).encode())
  payload_encoded = encode_payload(json.dumps(jwt_payload).encode())

  # Create the message to sign (header + payload)
  message = f'{header_encoded}.{payload_encoded}'
  hash_digest = sha384(message.encode()).digest()

  sign_result = akv_client.sign_value(key_name, hash_digest, 'es384')
  signature_encoded = encode_payload(sign_result.signature)

  signed_token = f'{header_encoded}.{payload_encoded}.{signature_encoded}'

  post_data = {
    'grant_type': 'client_credentials',
    'client_assertion_type': 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
    'client_assertion': signed_token
  }
  headers = {'Content-Type': 'application/x-www-form-urlencoded'}
  response = requests.post(auth_url, data=post_data, headers=headers, timeout=60)

  if response.status_code == 200:
    return json.loads(response.text)['access_token']

  raise RuntimeError('AccessToken not found')

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='Get Bearer Token for FHIR API')
  parser.add_argument('--env', type=str, choices=['sbox', 'stg', 'prod'], help='target environment', required=True)
  args = parser.parse_args()

  run(args.env)
