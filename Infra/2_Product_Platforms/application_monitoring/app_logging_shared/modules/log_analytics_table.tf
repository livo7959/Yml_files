resource "azapi_resource" "dcr_lhapps" {
  name      = "lhapps_CL"
  parent_id = module.log_analytics_workspace.resource_id
  type      = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  body = jsonencode(
    {
      "properties" : {
        "schema" : {
          "name" : "lhapps_CL",
          "columns" : [
            {
              "name" : "TimeGenerated",
              "type" : "datetime",
            },
            {
              "name" : "RawData",
              "type" : "string",
            },
            {
              "name" : "TimeStamp",
              "type" : "string",
            },
            {
              "name" : "LogLevel",
              "type" : "string",
            },
            {
              "name" : "Message",
              "type" : "string",
            },

          ]
        },
        "retentionInDays" : 90,
        "totalRetentionInDays" : 90
      }
    }
  )
}
