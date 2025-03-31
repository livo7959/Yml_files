import logging
import os
import signal
import sys

from triggers.service_bus_trigger import ServiceBusQueueTrigger

logging.basicConfig(stream=sys.stdout, level=logging.INFO)

ENV = os.getenv('ENVIRONMENT')
HOST_NAME = f'lh-data-{ENV}.servicebus.windows.net'
QUEUE_NAME = 'data-fetcher'

def signal_handler(_sig, _frame, scope):
  logging.info('Graceful shutdown initiated...')
  scope.stop()

if __name__ == '__main__':
  service_bus_queue_trigger = ServiceBusQueueTrigger(HOST_NAME)

  # Register signal handler for graceful shutdown
  signal.signal(signal.SIGINT, lambda sig, frame: signal_handler(sig, frame, service_bus_queue_trigger))
  signal.signal(signal.SIGTERM, lambda sig, frame: signal_handler(sig, frame, service_bus_queue_trigger))

  try:
    service_bus_queue_trigger.start(QUEUE_NAME)
  except Exception as ex:
    logging.exception('Exception caught: %s', ex, stack_info=True)
    service_bus_queue_trigger.stop()
