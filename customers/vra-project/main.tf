provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = var.insecure
}

data "vra_zone" "this" {
  name = var.zone_name
}

resource "vra_project" "this" {
  name        = var.project_name
  description = "Terraform-created project"

  zone_assignments {
    zone_id          = data.vra_zone.this.id
    priority         = 1
    max_instances    = 2
    cpu_limit        = 1024
    memory_limit_mb  = 8192
    storage_limit_gb = 65536
  }

  shared_resources = false

  administrators = [var.usertoadd]

  operation_timeout = 6000

  machine_naming_template = "$${resource.name}-$${####}"

}

# Share Blueprints with Project in Service Broker

resource "vra_catalog_source_entitlement" "this" {
  catalog_source_id     = var.catalog_source_id
  project_id            = vra_project.this.id
}

