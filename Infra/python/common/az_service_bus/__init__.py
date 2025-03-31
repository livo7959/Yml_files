from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import logging
import threading
from typing import Callable, Dict, List

from azure.identity import DefaultAzureCredential
from azure.servicebus import ServiceBusClient, ServiceBusMessage, ServiceBusReceiver
from azure.servicebus.exceptions import MessageSizeExceededError
from jsonschema import validate, ValidationError, SchemaError

class AzureServiceBus:
  _instance = None
  _lock = threading.Lock()

  def __new__(cls, host_name: str):
    if cls._instance is None:
      with cls._lock:
        if cls._instance is None:
          cls._instance = super(AzureServiceBus, cls).__new__(cls)
          cls._instance._initialize(host_name)
    return cls._instance

  def _initialize(self, host_name: str):
    self.host_name = host_name
    self._service_bus_client = ServiceBusClient(host_name, DefaultAzureCredential())

  def send_message_to_queue(self, queue_name: str, message_content: str):
    with self._service_bus_client.get_queue_sender(queue_name) as sender:
      message = ServiceBusMessage(message_content)
      sender.send_messages(message)
      logging.info('Sent message_id %s', message.message_id)

  def send_messages_to_queue(self, queue_name: str, messages: List[str | ServiceBusMessage]):
    with self._service_bus_client.get_queue_sender(queue_name) as sender:
      # Create the initial batch
      batch = sender.create_message_batch()
      for message in messages:
        if isinstance(message, str):
          message = ServiceBusMessage(message)
        try:
          # Attempt to add the message to the batch
          batch.add_message(message)
        except MessageSizeExceededError:
          # Batch is full, send the current batch
          sender.send_messages(batch)
          logging.info('Sent %s messages in single batch', len(batch))

          # Start a new batch and add the current message
          batch = sender.create_message_batch()
          batch.add_message(message)

      # Send any remaining messages
      if len(batch) > 0:
        sender.send_messages(batch)
        logging.info('Sent %s messages in final batch', len(batch))

  def _send_to_deadletter(self, receiver: ServiceBusReceiver, message: ServiceBusMessage, reason: str):
    receiver.dead_letter_message(message)
    logging.info('Sent message %s to dead_letter. %s', message.message_id, reason)

  def _validate_message(self, message: ServiceBusMessage, message_schema: Dict):
    """
    Validate the message content using the predefined schema.
    """
    try:
      message_data = json.loads(str(message))
      validate(instance=message_data, schema=message_schema)
      return True
    except (json.JSONDecodeError, SchemaError) as err:
      logging.error('Invalid message %s format: %s', message.message_id, err)
      return False
    except ValidationError as err:
      logging.error('Message %s validation failed: %s', message.message_id, err.message)
      return False

  def listen_to_queue(self, queue_name: str, message_schema: Dict, callback: Callable[[ServiceBusMessage, str], bool], shutdown_event: threading.Event, executor: ThreadPoolExecutor):
    with self._service_bus_client.get_queue_receiver(queue_name) as receiver:
      logging.info('Waiting for messages in %s', queue_name)
      while not shutdown_event.is_set():
        future_to_message = {}
        try:
          messages = receiver.receive_messages(max_message_count=5, max_wait_time=5)
          if not messages:
            continue

          logging.info('Received %s messages', len(messages))
          for message in messages:
            if not self._validate_message(message, message_schema):
              self._send_to_deadletter(receiver, message, f'Message {message.message_id} contents are invalid')
              continue
            future = executor.submit(callback, message, queue_name)
            future_to_message[future] = message

          for future in as_completed(future_to_message):
            message = future_to_message[future]
            if not future.result():
              self._send_to_deadletter(receiver, message, f'Unable to process message {message.message_id}')
              continue
            receiver.complete_message(message)
        except Exception as ex:
          logging.exception('Exception caught: %s', ex, stack_info=True)
