# VM network
resource "proxmox_virtual_environment_network_linux_bridge" "vmbr1" {
  node_name  = var.pm_node_name
  name       = "vmbr1"
  vlan_aware = true
  comment    = "LAN VMs"
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan1" {
  node_name = var.pm_node_name
  name      = "${proxmox_virtual_environment_network_linux_bridge.vmbr1.name}.1"

  comment = "VLAN VMs - 10.0.10.0/24"
}
