targetScope = 'tenant'
param management_groups array

module management_groups_creation './management_group/create_management_group.bicep' = [for management_group in management_groups: {
  name: 'management_group_creation_${management_group.name}'
  params: {
    mg_name: management_group.name
    mg_display_name: management_group.display_name
    mg_parent_name: contains(management_group, 'mg_parent_name') ? 'mg-${management_group.mg_parent_name}' : tenant().tenantId
    subscriptions: management_group.subscriptions
  }
}]
