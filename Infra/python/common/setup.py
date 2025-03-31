import setuptools

setuptools.setup(
  name='common',
  version='0.0.1',
  packages=setuptools.find_packages(),
  install_requires=[
    'azure-identity==1.18.0',
    'azure-keyvault-certificates==4.8.0',
    'azure-keyvault-keys==4.9.0',
    'azure-keyvault-secrets==4.8.0',
    'azure-servicebus==7.12.3',
    'azure-storage-blob==12.20.0',
    'azure-storage-file-datalake==12.15.0',
    'jsonschema==4.23.0'
  ],
  python_requires='>=3.12'
)
