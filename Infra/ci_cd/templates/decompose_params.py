import json
from typing import Dict, List

BASE_PATH = './bicep/params'

def handle_mg_unnesting(mg_config: Dict[str, str], result_set: List[Dict[str, str]]) -> Dict[str, str]:
    if 'management_groups' in mg_config:
        child_mg_configs = mg_config.pop('management_groups')
        result_set.append(mg_config)
        for child_mg_config in child_mg_configs:
            child_mg_config['mg_parent_name'] = mg_config['name']
            handle_mg_unnesting(child_mg_config, result_set)
    else:
        result_set.append(mg_config)

def load_network_security_group_params(nsg_configs: List[Dict[str, str]]):
    for nsg_config in nsg_configs:
        if 'security_rules_params' in nsg_config:
            with open(f"{BASE_PATH}/{nsg_config['security_rules_params']}", 'r') as security_rules_params:
                security_rules_params_json = json.load(security_rules_params)
                if 'security_rules' in nsg_config:
                    nsg_config['security_rules'].update(security_rules_params_json)
                else:
                    nsg_config['security_rules'] = security_rules_params_json

def load_rg_permission_params(resource_group_config: Dict[str, str]):
    with open(f"{BASE_PATH}/{resource_group_config['permission_params']}", 'r') as permission_params:
        permission_params_json = json.load(permission_params)
        resource_group_config['permissions'] = permission_params_json

def load_rg_resource_params(resource_group_config: Dict[str, str]):
    with open(f"{BASE_PATH}/{resource_group_config['resource_params']}", 'r') as resource_params:
        resource_params_json = json.load(resource_params)
        resource_group_config['resources'].update(resource_params_json)

def load_params(param_config: List[Dict[str, str]]):
    for management_group in param_config['parameters']['management_groups']['value']:
        if 'subscriptions' not in management_group:
            continue
        for subscription in management_group['subscriptions']:
            if 'resource_groups' not in subscription:
                continue
            for resource_group in subscription['resource_groups']:
                # Set default empty resource & permission fields
                if 'resources' not in resource_group:
                    resource_group['resources'] = {}

                if 'permissions' not in resource_group:
                    resource_group['permissions'] = {}

                if 'mode' not in resource_group:
                    resource_group['mode'] = 'complete'

                # Load param files
                if 'resource_params' in resource_group:
                    load_rg_resource_params(resource_group)

                # Load Resource specific param files
                if 'network_security_groups' in resource_group['resources']:
                    load_network_security_group_params(resource_group['resources']['network_security_groups'])

                if 'permission_params' in resource_group:
                    load_rg_permission_params(resource_group)

if __name__ == '__main__':
    with open(f'{BASE_PATH}/params.json', 'r') as params_file:
        param_file_contents = json.load(params_file)

        all_mgs = []

        for mg in param_file_contents['parameters']['management_groups']['value']:
            handle_mg_unnesting(mg, all_mgs)

        param_file_contents['parameters']['management_groups']['value'] = all_mgs

        load_params(param_file_contents)

        with open(f'{BASE_PATH}/prepared_params.json', 'w') as prepared_params_file:
            prepared_params_file.write(json.dumps(param_file_contents, indent=2))
