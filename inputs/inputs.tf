variable "vsphere_user" {
  type = string
  description = "The username of the vCenter user."
}

variable "vsphere_password" {
  type = string
  description = "The vCenter user's password."
}

variable "vsphere_server" {
  type = string
  description = "The vCenter server hostname."
  default = "wdc-vc-ins-a.sqa.local"
}

variable "vsphere_datacenter" {
  type = string
  description = "The datacenter to use for deployments."
  default = "VC-INS-A-Datacenter"
}

variable "vsphere_resource_pool" {
  type = string
  description = "The resource pool to use for deployments."
  default = "JPickhardt"
}

variable "vsphere_datastore" {
  type = string
  description = "The datastore to use for deployments."
  default = "wdc-eso-ins-a-VMs-1"
}

variable "vsphere_network" {
  type = string
  description = "The network to use for deployments."
  default = "dvPortGroup-private-sdm-4050"
}

variable "vsphere_virtual_machine_template" {
  type = string
  description = "The resource pool to use for deployments."
  default = "cbp_centos73x64"
}

variable "base-vm-name" {
  type = string
  description = "The base name to use for the generated VM. Will have numeric suffix for uniqueness."
  default = "terraform-test"
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_resource_pool" "pool" {
  name = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name = var.vsphere_virtual_machine_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

resource "vsphere_virtual_machine" "vm" {
  name             = "{var.base-vm-name}-${random_integer.suffix.result}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 1
  memory   = 512
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}

output "vm_name" {
    value = "${vsphere_virtual_machine.vm.name}"
}
