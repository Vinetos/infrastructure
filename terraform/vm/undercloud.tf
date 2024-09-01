resource "proxmox_virtual_environment_vm" "rke2_undercloud_controllers" {
  count     = var.rke2_undercloud_controllers_count
  name      = "rke2-undercloud-ctrl-${count.index}"
  node_name = var.pm_node_name
  vm_id     = 200 + count.index

  cpu {
    cores = var.rke2_undercloud_controllers_cpu
  }

  memory {
    dedicated = var.rke2_undercloud_controllers_memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = 1
  }

  disk {
    datastore_id = "data"
    file_id      = proxmox_virtual_environment_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    size         = 32
    discard      = "on"
  }

  boot_order = ["scsi0"]

  serial_device {}
  # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.0.10.${10 + count.index}/24"
        gateway = "10.0.10.1"
      }
    }

    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_config.id
  }
}

resource "proxmox_virtual_environment_vm" "rke2_undercloud_agents" {
  count     = var.rke2_undercloud_controllers_count
  name      = "rke2-undercloud-agents-${count.index}"
  node_name = var.pm_node_name
  vm_id     = 203 + count.index # I assume to have max 3 controllers

  cpu {
    cores = var.rke2_undercloud_controllers_cpu
  }

  memory {
    dedicated = var.rke2_undercloud_controllers_memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = 1
  }

  disk {
    datastore_id = "data"
    file_id      = proxmox_virtual_environment_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    size         = 32
    discard      = "on"
  }

  boot_order = ["scsi0"]

  serial_device {}
  # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.0.10.${13 + count.index}/24" # I assume to have max 3 controllers
        gateway = "10.0.10.1"
      }
    }

    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_config.id
  }
}

# DNS configuration
resource "opnsense_unbound_host_override" "undercloud_lyn_vinetos_fr_override" {
  enabled    = true
  hostname   = "*"
  domain     = "undercloud.vinetos.fr"
  server     = proxmox_virtual_environment_vm.rke2_undercloud_agents[0].ipv4_addresses[1][0]
  depends_on = [proxmox_virtual_environment_vm.rke2_undercloud_agents]
}
