import argparse
import json
import os
import requests
from typing import Dict, Any

from azure.identity import DefaultAzureCredential

# Databricks instance URL
DATABRICKS_INSTANCE: str = os.getenv('DATABRICKS_HOST')  # e.g., 'https://<databricks-instance>'
TOKEN: str = DefaultAzureCredential().get_token('2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default').token

def make_authenticated_request(endpoint: str, method: str = 'GET', data: Dict[str, Any] = None) -> Dict[str, Any]:
  '''
  Makes an authenticated request to the specified endpoint using the provided method and data.

  Args:
    endpoint (str): The endpoint to make the request to.
    method (str, optional): The HTTP method to use for the request. Defaults to 'GET'.
    data (Dict[str, Any], optional): The data to include in the request payload. Defaults to None.

  Returns:
    Dict[str, Any]: The JSON response from the request.

  Raises:
    requests.HTTPError: If the request fails with a non-2xx status code.
  '''
  url = f'{DATABRICKS_INSTANCE}/api/2.0/{endpoint}'
  headers = {
    'Authorization': f'Bearer {TOKEN}',
    'Content-Type': 'application/json'
  }

  response = requests.request(method, url, headers=headers, json=data)
  response.raise_for_status()

  return response.json()


def dashboard_get_status(dashboard_name: str) -> Dict[str, Any]:
  '''
  Retrieves the status of a Databricks dashboard.

  Args:
    dashboard_name (str): The name of the dashboard.

  Returns:
    Dict[str, Any]: A dictionary containing the status of the dashboard.

  '''
  endpoint = 'workspace/get-status'
  data = {
    'path': f'/Workspace/Shared/dashboards/{dashboard_name}.lvdash.json'
  }
  return make_authenticated_request(endpoint, data=data)

def get_dashboard_by_id(dashboard_id: str) -> Dict[str, Any]:
  '''
  Retrieves a Databricks dashboard by its ID.

  Args:
    dashboard_id (str): The ID of the dashboard to retrieve.

  Returns:
    Dict[str, Any]: A dictionary containing the dashboard information.

  '''
  endpoint = f'lakeview/dashboards/{dashboard_id}'
  return make_authenticated_request(endpoint)

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--dashboard_id', help='Id of the dashboard', type=str, default='')
  args = parser.parse_args()

  dashboard_id = args.dashboard_id

  if dashboard_id:
    dashboard_details = get_dashboard_by_id(dashboard_id)
    print(json.dumps({
      'serialized_dashboard': dashboard_details['serialized_dashboard']
    }))
  else:
    resp = make_authenticated_request('lakeview/dashboards')
    output = {'dashboards': json.dumps(resp.get('dashboards', []))}
    print(json.dumps(output))
