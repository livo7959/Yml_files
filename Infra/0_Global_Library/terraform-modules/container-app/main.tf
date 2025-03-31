resource "azurerm_container_app" "this" {
  name                         = "ca-${local.base_name}"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode
  workload_profile_name        = var.workload_profile_name
  max_inactive_revisions       = var.max_inactive_revisions
  tags                         = local.merged_tags

  template {

    min_replicas    = var.template.min_replicas
    max_replicas    = var.template.max_replicas
    revision_suffix = var.template.revision_suffix

    dynamic "container" {
      for_each = var.template.container

      content {
        name    = container.value.name
        image   = container.value.image
        cpu     = container.value.cpu
        memory  = container.value.memory
        args    = container.value.args
        command = container.value.command
        dynamic "env" {
          for_each = container.value.env
          content {
            name        = env.value.name
            secret_name = env.value.secret.name
            value       = env.value.value
          }
        }
        dynamic "liveness_probe" {
          for_each = container.value.liveness_probe != null ? [container.value.liveness_probe] : []
          content {
            port                             = liveness_probe.value.port
            transport                        = liveness_probe.value.transport
            failure_count_threshold          = liveness_probe.value.failure_count_threshold
            host                             = liveness_probe.value.host
            initial_delay                    = liveness_probe.value.initial_delay
            interval_seconds                 = liveness_probe.value.interval_seconds
            path                             = liveness_probe.value.path
            termination_grace_period_seconds = liveness_probe.value.termination_grace_period_seconds
            timeout                          = liveness_probe.value.timeout
            dynamic "header" {
              for_each = liveness_probe.value.header
              content {
                name  = header.key
                value = header.value
              }
            }

          }
        }
        dynamic "startup_probe" {
          for_each = container.value.startup_probe != null ? [container.value.startup_probe] : []
          content {
            port                             = startup_probe_probe.value.port
            transport                        = startup_probe.value.transport
            failure_count_threshold          = startup_probe.value.failure_count_threshold
            host                             = startup_probe.value.host
            initial_delay                    = startup_probe.value.ininitial_delay
            interval_seconds                 = startup_probe.value.interval_seconds
            path                             = startup_probe.value.path
            termination_grace_period_seconds = startup_probe.value.termination_grace_period_seconds
            timeout                          = startup_probe.value.timeout
            dynamic "header" {
              for_each = liveness_probe.value.header
              content {
                name  = header.key
                value = header.value
              }
            }
          }

        }
        dynamic "readiness_probe" {
          for_each = container.value.readiness_probe != null ? [container.value.readiness_probe] : []
          content {
            port                    = readiness_probe_probe.value.port
            transport               = readiness_probe.value.transport
            failure_count_threshold = readiness_probe.value.failure_count_threshold
            host                    = readiness_probe.value.host
            initial_delay           = readiness_probe.value.ininitial_delay
            interval_seconds        = readiness_probe.value.interval_seconds
            path                    = readiness_probe.value.path
            success_count_threshold = readiness_probe.value.success_count_threshold
            timeout                 = readiness_probe.value.timeout
            dynamic "header" {
              for_each = liveness_probe.value.header
              content {
                name  = header.key
                value = header.value
              }
            }
          }
        }
      }
    }
    dynamic "http_scale_rule" {
      for_each = var.template.http_scale_rule
      content {
        name                = http_scale_rule.value.name
        concurrent_requests = http_scale_rule.value.concurrent_requests
        dynamic "authentication" {
          for_each = http_scale_rule.value.authentication != null ? http_scale_rule.value.authentication : []
          content {
            secret_name       = authentication.value.secret_name
            trigger_parameter = authentication.value.trigger_parameter
          }
        }
      }
    }

    dynamic "tcp_scale_rule" {
      for_each = var.template.tcp_scale_rule
      content {
        name                = tcp_scale_rule.value.name
        concurrent_requests = tcp_scale_rule.value.concurrent_requests
        dynamic "authentication" {
          for_each = tcp_scale_rule.value.authentication != null ? tcp_scale_rule.value.authentication : []
          content {
            secret_name       = authentication.value.secret_name
            trigger_parameter = authentication.value.trigger_parameter
          }
        }
      }
    }

    dynamic "custom_scale_rule" {
      for_each = var.template.custom_scale_rule
      content {
        name             = custom_scale_rule.value.name
        custom_rule_type = custom_scale_rule.value.custom_rule_type
        metadata         = custom_scale_rule.value.metadata
        dynamic "authentication" {
          for_each = custom_scale_rule.value.authentication != null ? custom_scale_rule.value.authentication : []
          content {
            secret_name       = authentication.value.secret_name
            trigger_parameter = authentication.value.trigger_parameter
          }
        }
      }
    }
  }

  dynamic "dapr" {
    for_each = var.dapr != null ? [var.dapr] : []
    content {
      app_id       = dapr.value.app_id
      app_port     = dapr.value.app_port
      app_protocol = dapr.value.app_protocol
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "ingress" {
    for_each = var.ingress != null ? [var.ingress] : []
    content {
      allow_insecure_connections = ingress.value.allow_insecure_connections
      fqdn                       = ingress.value.fqdn
      external_enabled           = ingress.value.external_enabled
      target_port                = ingress.value.target_port
      exposed_port               = ingress.value.exposed_port
      transport                  = ingress.value.transport
      dynamic "traffic_weight" {
        for_each = ingress.value.traffic_weight
        content {
          label           = traffic_weight.value.label
          latest_revision = traffic_weight.value.latest_revision
          revision_suffix = traffic_weight.value.revision_suffix
          percentage      = traffic_weight.value.percentage

        }
      }
      dynamic "ip_security_restriction" {
        for_each = ingress.value.ip_security_restriction
        content {
          action           = ip_security_restriction.value.action
          description      = ip_security_restriction.value.description
          ip_address_range = ip_security_restriction.value.ip_address_range
          name             = ip_security_restriction.value.name
        }
      }
    }
  }

  dynamic "registry" {
    for_each = var.registry != null ? [var.registry] : []
    content {
      server               = registry.value.server
      identity             = registry.value.identity
      password_secret_name = registry.value.password_secret_name
      username             = registry.value.username
    }
  }

  dynamic "secret" {
    for_each = var.secret != null ? [var.secret] : []
    content {
      name                = secret.value.name
      identity            = secret.value.identity
      key_vault_secret_id = secret.value.key_vault_secret_id
      value               = secret.value.value

    }
  }

}
