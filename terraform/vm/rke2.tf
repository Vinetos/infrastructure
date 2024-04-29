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
    iothread     = true
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
        address = "dhcp"
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
    iothread     = true
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
        address = "dhcp"
      }
    }

    interface         = "ide2"
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_config.id
  }
}

# DNS configuration
resource "opnsense_unbound_host_override" "underclouod_lyn_vinetos_fr_override" {
  enabled    = true
  hostname   = "*"
  domain     = "undercloud.vinetos.fr"
  server     = proxmox_virtual_environment_vm.rke2-controllers[0].ipv4_addresses[1][0]
  depends_on = [proxmox_virtual_environment_vm.rke2-controllers]
}


# Ansible inventory definition
resource "ansible_group" "rke2" {
  name     = "rke2"
  children = [ansible_group.rke2-controllers.name, ansible_group.rke2-workers.name]
}

resource "ansible_group" "rke2-controllers" {
  name = "rke2-controllers"
}

resource "ansible_group" "rke2-workers" {
  name = "rke2-workers"
}


# Inventory host resource.
resource "ansible_host" "rke2-controllers" {
  for_each = toset([for instance in proxmox_virtual_environment_vm.rke2-controllers : instance.ipv4_addresses[1][0]])
  name     = each.value

  groups = [ansible_group.rke2-controllers.name] # Groups this host is part of.

  #   variables = {
  #     # Connection vars.
  #     ansible_user = "admin" # Default user depends on the OS.
  #
  #     # Custom vars that we might use in roles/tasks.
  #     hostname = "web1"
  #     fqdn     = "web1.example.com"
  #   }
}

resource "ansible_host" "rke2-workers" {
  for_each = toset([for instance in proxmox_virtual_environment_vm.rke2-workers : instance.ipv4_addresses[1][0]])
  name     = each.value

  groups = [ansible_group.rke2-workers.name]
}
