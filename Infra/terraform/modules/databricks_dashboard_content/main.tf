data "external" "dashboards" {
  program = [
    "pwsh",
    "-File",
    "${path.module}/list_dashboards.ps1",
    "${path.module}"
  ]
}

data "external" "dashboard_details" {
  for_each = {
    for idx, each in jsondecode(data.external.dashboards.result["dashboards"]) :
    each.display_name => each.dashboard_id
  }

  program = [
    "pwsh",
    "-File",
    "${path.module}/dashboard_details.ps1",
    each.value,
    "${path.module}"
  ]
}
