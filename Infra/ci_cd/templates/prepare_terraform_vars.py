import json
import shutil
from typing import Dict

BASE_PATH = './terraform/params/environments'

def load_extended_var_file(resource_group_config: Dict[str, str], file_name: str, env: str):
    with open(f"{BASE_PATH}/{env}/{file_name}", 'r') as resource_params:
        resource_params_json = json.load(resource_params)
        resource_group_config.update(resource_params_json)

def load_extended_params(param_config: Dict[str, str], env: str):
    for resource_group in param_config['resource_groups']:
        if 'extended_var_files' not in resource_group:
            continue
        for extended_var_file in resource_group['extended_var_files']:
            load_extended_var_file(resource_group, extended_var_file, env)

        del resource_group['extended_var_files']

if __name__ == '__main__':
    for environment in ['sandbox', 'dev', 'prod']:
        with open(f'{BASE_PATH}/{environment}/{environment}.tfvars.json', 'r') as params_file:
            param_file_contents = json.load(params_file)

            load_extended_params(param_file_contents, environment)

            with open(f'{BASE_PATH}/{environment}/prepared_{environment}.tfvars.json', 'w') as prepared_params_file:
                prepared_params_file.write(json.dumps(param_file_contents, indent=2))

        shutil.copyfile(f'{BASE_PATH}/../common/main.tf', f'{BASE_PATH}/{environment}/main.tf')
        shutil.copyfile(f'{BASE_PATH}/../common/providers.tf', f'{BASE_PATH}/{environment}/providers.tf')
        shutil.copyfile(f'{BASE_PATH}/../common/variables.tf', f'{BASE_PATH}/{environment}/variables.tf')
