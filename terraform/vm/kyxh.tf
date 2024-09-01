resource "proxmox_virtual_environment_vm" "kyxh_vms" {
  count     = 1
  name      = "kyxh-vms-${count.index}"
  node_name = var.pm_node_name
  vm_id     = 300 + count.index

  cpu {
    cores = 4
  }

  memory {
    dedicated = 8192
  }

  agent {
    enabled = true
  }

  network_device {
    bridge  = "vmbr2"
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
        address = "10.0.30.${10 + count.index}/24"
        gateway = "10.0.30.1"
      }
    }

    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_config.id
  }
}
