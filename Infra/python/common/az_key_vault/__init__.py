from datetime import datetime
import logging
import threading

from azure.core.polling import LROPoller
from azure.identity import DefaultAzureCredential
from azure.keyvault.certificates import CertificateClient, CertificateOperation, CertificatePolicy, DeletedCertificate, KeyVaultCertificate
from azure.keyvault.keys import DeletedKey, KeyClient, KeyType, KeyVaultKey
from azure.keyvault.keys.crypto import CryptographyClient, SignatureAlgorithm, SignResult
from azure.keyvault.secrets import DeletedSecret, KeyVaultSecret, SecretClient
from typing import Optional

class AzureKeyVault:
  _instance = None
  _lock = threading.Lock()

  def __new__(cls, vault_url):
    if cls._instance is None:
      with cls._lock:
        if cls._instance is None:
          cls._instance = super(AzureKeyVault, cls).__new__(cls)
          cls._instance._initialize(vault_url)
    return cls._instance

  def _initialize(self, vault_url):
    self._credential = DefaultAzureCredential()
    self._secret_client = SecretClient(vault_url=vault_url, credential=self._credential)
    self._key_client = KeyClient(vault_url=vault_url, credential=self._credential)
    self._certificate_client = CertificateClient(vault_url=vault_url, credential=self._credential)
    self._crypto_clients = {}

  def _get_crypto_client(self, key: KeyVaultKey) -> CryptographyClient:
    if key.id not in self._crypto_clients:
      self._crypto_clients[key.id] = CryptographyClient(key, self._credential)
    return self._crypto_clients[key.id]

  def set_secret(self, secret_name: str, secret_value: str, expires_on: Optional[datetime] = None) -> KeyVaultSecret:
    return self._secret_client.set_secret(secret_name, secret_value, expires_on=expires_on)

  def get_secret(self, secret_name: str) -> KeyVaultSecret:
    return self._secret_client.get_secret(secret_name)

  def get_secret_value(self, secret_name: str) -> str:
    return self.get_secret(secret_name).value

  def delete_secret(self, secret_name: str) -> LROPoller[DeletedSecret]:
    deleted_secret_poller = self._secret_client.begin_delete_secret(secret_name)
    logging.info("Secret '%s' deleting", secret_name)
    return deleted_secret_poller

  def set_key(self, key_name: str, key_type: str | KeyType) -> KeyVaultKey:
    key = self._key_client.create_key(key_name, key_type)
    logging.info("Key '%s' of type '%s' set", key_name, key_type)
    return key

  def get_key(self, key_name: str) -> KeyVaultKey:
    key = self._key_client.get_key(key_name)
    logging.info("Key '%s' retrieved", key_name)
    return key

  def delete_key(self, key_name: str) -> LROPoller[DeletedKey]:
    deleted_key_poller = self._key_client.begin_delete_key(key_name)
    logging.info("Key '%s' deleted", key_name)
    return deleted_key_poller

  def set_certificate(self, cert_name: str, policy: CertificatePolicy) -> LROPoller[KeyVaultCertificate | CertificateOperation]:
    certificate_poller = self._certificate_client.begin_create_certificate(cert_name, policy)
    logging.info("Certificate '%s' set with policy '%s'", cert_name, policy)
    return certificate_poller

  def get_certificate(self, cert_name: str) -> KeyVaultCertificate:
    certificate = self._certificate_client.get_certificate(cert_name)
    logging.info("Certificate '%s' retrieved", cert_name)
    return certificate

  def delete_certificate(self, cert_name: str) -> LROPoller[DeletedCertificate]:
    deleted_certificate_poller = self._certificate_client.begin_delete_certificate(cert_name)
    logging.info("Certificate '%s' deleted", cert_name)
    return deleted_certificate_poller

  def sign_value(self, key_name: str, value_to_sign: str, signing_algorithm: SignatureAlgorithm) -> SignResult:
    key = self.get_key(key_name)
    crypto_client = self._get_crypto_client(key)
    return crypto_client.sign(signing_algorithm, value_to_sign)
