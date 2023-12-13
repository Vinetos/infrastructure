### NETWORKS
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

#resource "proxmox_virtual_environment_vm" "proxmox_vm_opnsense" {
#  name  = "opnsense"
#  vm_id = 100 # I want OPNsense to be VM 100
#  count = 1
#  target_node = var.pm_node_name
#
#  clone   = var.template_vm_name
#  iso = "promox:iso/OPNsense-23.7-dvd-amd64.iso"
#
#  define_connection_info = true
#  memory                 = 4096
#  cores                  = 2
#  cpu                    = "x86-64-v2-AES"
#  scsihw                 = "virtio-scsi-pci"
#  qemu_os                = "l26"
#
#  ipconfig0 = "ip=dhcp"
#
#  lifecycle {
#    ignore_changes = [
#      ciuser,
#      sshkeys,
#      disk,
#      network
#    ]
#  }
#
#}

## K3s cluster
#resource "proxmox_vm_qemu" "proxmox_vm_master" {
#  count = var.num_k3s_masters
#  name  = "k3s-master-${count.index}"
#
#  target_node = var.pm_node_name
#
#  clone   = var.template_vm_name
#  os_type = "cloud-init"
#
#  agent                  = 1
#  define_connection_info = true
#  memory                 = var.num_k3s_masters_mem
#  cores                  = 4
#  cpu                    = "x86-64-v2-AES"
#  scsihw                 = "virtio-scsi-pci"
#  qemu_os                = "l26"
#
#  tags = "k3s"
#  oncreate = true
#
#  ipconfig0 = "ip=dhcp"
#
#  lifecycle {
#    ignore_changes = [
#      ciuser,
#      sshkeys,
#      disk,
#      network
#    ]
#  }
#
#}
#
#resource "proxmox_vm_qemu" "proxmox_vm_workers" {
#  count = var.num_k3s_nodes
#  name  = "k3s-worker-${count.index}"
#
#  target_node = var.pm_node_name
#
#  clone   = var.template_vm_name
#  os_type = "cloud-init"
#
#  agent                  = 1
#  define_connection_info = true
#  memory                 = var.num_k3s_nodes_mem
#  cores                  = 4
#  cpu                    = "x86-64-v2-AES"
#  scsihw                 = "virtio-scsi-pci"
#  qemu_os                = "l26"
#
#  tags = "k3s"
#  oncreate = true
#
#  ipconfig0 = "ip=dhcp"
#
#  lifecycle {
#    ignore_changes = [
#      ciuser,
#      sshkeys,
#      disk,
#      network
#    ]
#  }
#
#}
#
## Gitlab server
#resource "proxmox_vm_qemu" "proxmox_vm_gitlab" {
#  count = 1
#  name  = "gitlab"
#
#  target_node = var.pm_node_name
#
#  clone   = var.template_vm_name
#  os_type = "cloud-init"
#
#  agent                  = 1
#  define_connection_info = true
#  memory                 = var.num_gitlab_mem
#  cores                  = 4
#  cpu                    = "x86-64-v2-AES"
#  scsihw                 = "virtio-scsi-pci"
#  qemu_os                = "l26"
#
#  tags = "admin"
#  oncreate = true
#
#  ipconfig0 = "ip=dhcp"
#
#  lifecycle {
#    ignore_changes = [
#      ciuser,
#      sshkeys,
#      disk,
#      network
#    ]
#  }
#
#}
#
#data "template_file" "k3s" {
#  template = file("./templates/k3s.tpl")
#  vars = {
#    k3s_master_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_master : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
#    k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
#  }
#}
#
#resource "local_file" "k8s_file" {
#  content  = data.template_file.k8s.rendered
#  filename = "../inventory/my-cluster/hosts.ini"
#}
#
#resource "local_file" "var_file" {
#  source   = "../inventory/sample/group_vars/all.yml"
#  filename = "../inventory/my-cluster/group_vars/all.yml"
#}
