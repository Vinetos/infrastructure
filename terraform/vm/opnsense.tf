# OPNsense
resource "proxmox_virtual_environment_vm" "opnsense_vm" {
  name = "opnsense"

  node_name = var.pm_node_name
  vm_id     = 100

  memory {
    dedicated = 4096
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  startup {
    order      = "1"
    up_delay   = "0"
    down_delay = "0"
  }

  disk {
    datastore_id = "data"
    file_format = "raw"
    interface    = "scsi0"
    size         = 32
  }

  network_device {
    bridge = "vmbr0"
  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = 1
  }

  operating_system {
    type = "l26"
  }
}
