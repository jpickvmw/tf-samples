provider "vsphere" {
  user           = "administrator@vsphere.local" 
  password       = "VMware1!"
  vsphere_server = "vc02.space.local" 

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "SPACE-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "QNAP-SSD-01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Cluster-01/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name		= "TEMP-CentOS7"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 1024
  wait_for_guest_net_timeout 	= 5
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
#  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id = data.vsphere_network.network.id
#    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
#    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
#    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }  

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "terraform-test"
        domain    = "space.local"
    }
    network_interface {}
  }
}
}
