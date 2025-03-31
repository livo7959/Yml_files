
param (
  [string]$module_path
)

pip install -r ./requirements.txt > $null
python $module_path/get_databricks_dashboards.py
