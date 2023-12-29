resource "proxmox_virtual_environment_vm" "k3s-masters-vm" {
  count     = var.k3s_masters_count
  name      = "k3s-master-${count.index}"
  node_name = var.pm_node_name
  vm_id     = 200 + count.index

  cpu {
    cores = var.k3s_masters_cpu
  }

  memory {
    dedicated = var.k3s_masters_memory
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

resource "proxmox_virtual_environment_vm" "k3s-workers-vm" {
  count     = var.k3s_workers_count
  name      = "k3s-worker-${count.index}"
  node_name = var.pm_node_name
  vm_id     = 210 + count.index

  cpu {
    cores = var.k3s_workers_cpu
  }

  memory {
    dedicated = var.k3s_workers_memory
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
