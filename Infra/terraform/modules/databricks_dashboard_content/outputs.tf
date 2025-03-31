output "dashboard_contents" {
  value = {
    for idx, each in jsondecode(data.external.dashboards.result["dashboards"]) :
    each.display_name => data.external.dashboard_details[each.display_name].result["serialized_dashboard"]
  }
}
