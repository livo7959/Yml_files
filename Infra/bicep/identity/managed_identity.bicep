param location string
param environment_name string

param create_container_registry_id bool

resource container_app_mananged_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (create_container_registry_id) {
  name: 'container_app_acr_${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
}

output container_app_mananged_identity_id string = create_container_registry_id ? container_app_mananged_identity.id : ''
