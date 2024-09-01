# VM network
resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  node_name  = var.pm_node_name
  name       = "vmbr0"
  vlan_aware = true
  ports      = ["eno1"]
  comment    = "Host network"
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan200" {
  node_name = var.pm_node_name
  name      = "${proxmox_virtual_environment_network_linux_bridge.vmbr0.name}.200"

  address   = "10.20.0.8/24"
  gateway   = "10.20.0.1"
  interface = proxmox_virtual_environment_network_linux_bridge.vmbr0.name
  vlan      = 200

  comment = "VLAN Hyperviseur Atelier"
}

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

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr2" {
  node_name  = var.pm_node_name
  name       = "vmbr2"
  comment    = "Kyxh LAN VMs"
}
