import argparse
import base64
from hashlib import sha256
import json
from typing import Dict

from azure.keyvault.keys import KeyType

from az_storage import AzureStorage
from az_key_vault import AzureKeyVault

ENV_MAP = {
    'sbox': 'sbox',
    'stg': 'ostg',
    'prod': 'oprd'
}

def get_jwk_from_akv(vault_url: str, key_name: str, alg: str) -> Dict[str, str]:
    key = AzureKeyVault(vault_url).get_key(key_name)

    # Extract key details and format them as JWK
    match key.key_type:
      case KeyType.rsa:
        return {
          'kty': key.key_type,
          'kid': str(sha256(key.id.encode()).hexdigest()),
          'use': 'sig',
          'alg': alg,
          'n': base64.urlsafe_b64encode(key.key.n).decode('utf-8').rstrip('='),
          'e': base64.urlsafe_b64encode(key.key.e).decode('utf-8').rstrip('=')
        }
      case KeyType.ec:
        return {
          'kty': key.key_type,
          'kid': str(sha256(key.id.encode()).hexdigest()),
          'use': 'sig',
          'alg': alg,
          'crv': key.key.crv,
          'x': base64.urlsafe_b64encode(key.key.x).decode('utf-8'),
          'y': base64.urlsafe_b64encode(key.key.y).decode('utf-8')
        }
      case _:
        raise RuntimeError(f'Unsupported key_type: {key.key_type}')

def create_jwk_set(vault_url: str, keys: Dict[str, str]) -> Dict[str, Dict[str, str]]:
    jwk_set = {'keys': []}
    for key_name, alg in keys.items():
        jwk = get_jwk_from_akv(vault_url, key_name, alg)
        jwk_set['keys'].append(jwk)

    return jwk_set

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate JWK set')
    parser.add_argument('--env', type=str, choices=['sbox', 'stg', 'prod'], help='target environment', required=True)
    args = parser.parse_args()

    vault_url = f'https://lh-azkv-{args.env}.vault.azure.net/'
    keys = {
      'epic-fhir': 'RS256',
      'epic-fhir-ec384': 'ES384'
    }

    jwk_set = create_jwk_set(vault_url, keys)
    jwk_set_json = json.dumps(jwk_set, indent=2)

    # Save the JWK Set to a file
    AzureStorage(f'lhpublicdata{ENV_MAP[args.env]}').upload_data_to_filename(
        container_name='epic-fhir',
        blob_name='epic-fhir-jwks.json',
        data=jwk_set_json,
        content_type='application/json'
    )
