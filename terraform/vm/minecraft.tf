resource "proxmox_virtual_environment_vm" "mc-manager-vm" {
  count     = 1
  name      = "mc-manager"
  node_name = var.pm_node_name
  vm_id     = 300

  cpu {
    cores = 1
  }

  memory {
    dedicated = 2*1024
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
    size         = 16
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
        address = "dhcp"
      }
    }

    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_config.id
  }
}


resource "proxmox_virtual_environment_vm" "valhelsia-vm" {
  count     = 1
  name      = "mc-valhelsia"
  node_name = var.pm_node_name
  vm_id     = 301

  cpu {
    cores = 4
  }

  memory {
    dedicated = 32*1024
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
    size         = 256
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
        address = "dhcp"
      }
    }

    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_config.id
  }
}

output "mc-manager-ips" {
  value = join("\n", [for instance in proxmox_virtual_environment_vm.mc-manager-vm : instance.ipv4_addresses[1][0]])
}

