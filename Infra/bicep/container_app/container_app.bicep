param location string
param environment_name string

param container_apps array
param identity_id string

var container_app_env_name = 'lh-container-app-${environment_name}'

resource container_app_env 'Microsoft.App/managedEnvironments@2022-10-01' = if (!empty(container_apps)) {
  name: container_app_env_name
  location: location
  tags: {
    environment: environment_name
  }
  sku: {
    name: 'Consumption'
  }
  properties: {
    zoneRedundant: false
  }
}

resource managed_environment_managed_certificate 'Microsoft.App/managedEnvironments/managedCertificates@2023-05-01' = [for custom_domain in reduce(container_apps, [], (custom_domains, next_container_app) => concat(custom_domains, next_container_app.domains)): {
  parent: container_app_env
  name: (environment_name == 'prod') ? '${custom_domain.name}-certificate' : '${environment_name}.${custom_domain.name}-certificate'
  location: location
  tags: {
    environment: environment_name
  }
  properties: {
    subjectName: (environment_name == 'prod') ? custom_domain.name : '${environment_name}.${custom_domain.name}'
    domainControlValidation: 'CNAME'
  }
}]

resource container_app_resources 'Microsoft.App/containerApps@2022-10-01' = [for container_app in container_apps: {
  name: '${container_app.name}-${environment_name}'
  location: location
  tags: {
    environment: environment_name
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity_id}': {}
    }
  }
  properties: {
    configuration: {
      activeRevisionsMode: 'Single'
      registries: [
        {
          server: '${container_app.registry_name}${environment_name}.azurecr.io'
          identity: identity_id
        }
      ]
      ingress: {
        allowInsecure: false
        clientCertificateMode: 'require'
        external: true
        transport: 'auto'
        targetPort: 80
        customDomains: [ for domain in container_app.domains: {
          name: (environment_name == 'prod') ? domain.name : '${environment_name}.${domain.name}'
          bindingType: domain.binding_type
          certificateId: (domain.binding_type == 'SniEnabled') ? resourceId('Microsoft.App/managedEnvironments/managedCertificates', container_app_env_name, (environment_name == 'prod') ? '${domain.name}-certificate' : '${environment_name}.${domain.name}-certificate') : null
        }]
        ipSecurityRestrictions: [
          {
            action: 'Allow'
            name: 'LogixInternal'
            ipAddressRange: '66.97.189.250'
          }
        ]
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
    }
    environmentId: container_app_env.id
    template: {
      containers: [ for container in container_app.containers: {
        image: '${container_app.registry_name}${environment_name}.azurecr.io/${container.image_name}:latest'
        name: container.container_name
        resources: {
          cpu: json(container.cpu_core)
          memory: '${container.memory_size_gb}Gi'
        }
      }]
      scale: {
        maxReplicas: 3
        minReplicas: 1
      }
    }
  }
}]
