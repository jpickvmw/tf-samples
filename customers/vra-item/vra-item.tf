provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = var.insecure
}

data "vra_catalog_item" "this" {
  name		= var.blueprint_name
}

data "vra_project" "this" {
  name		= var.project_name
}

resource "vra_deployment" "this" {
  name        = "myresource"
  description = "terraform test deployment"

  catalog_item_id      = data.vra_catalog_item.this.id
#  catalog_item_version = vra_blueprint_version.this.version
  project_id           = data.vra_project.this.id

#  inputs = {
#    flavor = "small"
#    image  = "centos"
#  }

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}
