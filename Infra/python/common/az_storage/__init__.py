import logging
import mimetypes
import threading

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, ContentSettings
from typing import Optional

class AzureStorage:
  _instance = None
  _lock = threading.Lock()

  def __new__(cls, storage_account_name: str):
    if cls._instance is None:
      with cls._lock:
        if cls._instance is None:
          cls._instance = super(AzureStorage, cls).__new__(cls)
          cls._instance._initialize(storage_account_name)
    return cls._instance

  def _initialize(self, storage_account_name: str):
    account_url = f'https://{storage_account_name}.blob.core.windows.net'
    self._blob_service_client = BlobServiceClient(account_url=account_url, credential=DefaultAzureCredential())

  def upload_data_to_filename(self, container_name: str, blob_name: str, data: str, content_type: Optional[str] = None) -> None:
    blob_client = self._blob_service_client.get_blob_client(container=container_name, blob=blob_name)
    blob_client.upload_blob(
      data,
      overwrite=True,
      content_settings=ContentSettings(content_type=content_type or mimetypes.guess_type(blob_name)[0] or 'application/octet-stream')
    )
    logging.info("Data uploaded to blob '%s' in container '%s'.", blob_name, container_name)
