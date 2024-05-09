resource "proxmox_virtual_environment_vm" "rke2-controllers" {
  count     = var.rke2_controllers_count
  name      = "rke2-controllers-${count.index}"
  node_name = var.pm_node_name
  vm_id     = 200 + count.index

  cpu {
    cores = var.rke2_controllers_cpu
  }

  memory {
    dedicated = var.rke2_controllers_memory
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

resource "proxmox_virtual_environment_vm" "rke2-workers" {
  count     = var.rke2_workers_count
  name      = "rke2-worker-${count.index}"
  node_name = var.pm_node_name
  vm_id     = 210 + count.index

  cpu {
    cores = var.rke2_workers_cpu
  }

  memory {
    dedicated = var.rke2_workers_memory
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
          address = "10.0.10.${20 + count.index}/24"
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
  server     = proxmox_virtual_environment_vm.rke2-workers[0].ipv4_addresses[1][0]
  depends_on = [proxmox_virtual_environment_vm.rke2-workers]
}
