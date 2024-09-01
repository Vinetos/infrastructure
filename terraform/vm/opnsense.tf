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
    enabled = true
  }

  startup {
    order      = "1"
    up_delay   = "0"
    down_delay = "0"
  }

  cpu {
    architecture = "x86_64"
    cores        = 1
    type         = "x86-64-v2-AES"
  }

  disk {
    datastore_id = "data"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 32
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = 10
  }

  network_device {
    bridge  = "vmbr1"
    vlan_id = 1
  }

  network_device {
    bridge  = "vmbr2"
  }

  operating_system {
    type = "l26"
  }
}
