from azure.servicebus import ServiceBusMessage
from concurrent.futures import ThreadPoolExecutor
import json
import logging
from threading import Event

from az_service_bus import AzureServiceBus
from config_loader import load_config
from fetcher import Fetcher

class ServiceBusQueueTrigger:
  def __init__(self, host_name: str):
    self.host_name = host_name
    self.service_bus = AzureServiceBus(host_name)
    self.executor = ThreadPoolExecutor(max_workers=5)
    self.shutdown_event = Event()
    self.message_schema = {
      'type': 'object',
      'properties': {
        'source': {'type': 'string'},
        'operation': {'type': 'string'}
      },
      'required': [
        'source',
        'operation'
      ],
      'additionalProperties': True  # This will disallow extra fields
    }

  def handle_message(self, message: ServiceBusMessage, service_bus_queue_name: str) -> bool:
    message_data = json.loads(str(message))
    try:
      config = load_config('./configs/data-ingestion', message_data)
      Fetcher(config, message_data, self.host_name, service_bus_queue_name).run()
      return True
    except Exception as ex:
      logging.exception('Error processing message %s: %s', message.message_id, ex, stack_info=True)
      return False

  def start(self, queue_name: str):
    self.service_bus.listen_to_queue(queue_name, self.message_schema, self.handle_message, self.shutdown_event, self.executor)

  def stop(self):
    self.shutdown_event.set() # Signal the event to stop listening
    self.executor.shutdown(wait=True)
    logging.info('%s shut down successfully', __class__.__name__)
