resource "proxmox_virtual_environment_vm" "k8s_cp_01" {
  name      = "k8s-cp-01"
  node_name = var.pm_node_name

  cpu {
    cores = 2
  }

  memory {
    dedicated = 6144
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr1"
  }

  disk {
    datastore_id = "data"
    file_id      = proxmox_virtual_environment_file.cloud_config.id
    interface    = "scsi0"
    size         = 32
  }

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
  }
}

resource "proxmox_virtual_environment_vm" "k8s_worker_01" {
  name      = "k8s-worker-01"
  node_name = var.pm_node_name

  cpu {
    cores = 1
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "data"
    file_id      = proxmox_virtual_environment_file.cloud_config.id
    interface    = "scsi0"
    size         = 32
  }

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
  }
}