resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count = var.num_k3s_masters
  name  = "k3s-master-${count.index}"

  target_node = var.pm_node_name

  clone   = var.template_vm_name
  os_type = "cloud-init"

  agent                  = 1
  define_connection_info = true
  memory                 = var.num_k3s_masters_mem
  cores                  = 4
  cpu                    = "x86-64-v2-AES"
  scsihw                 = "virtio-scsi-pci"
  qemu_os                = "l26"

  tags = "k3s"


  ipconfig0 = "ip=dhcp"

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      network
    ]
  }

}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count = var.num_k3s_nodes
  name  = "k3s-worker-${count.index}"

  target_node = var.pm_node_name

  clone   = var.template_vm_name
  os_type = "cloud-init"

  agent                  = 1
  define_connection_info = true
  memory                 = var.num_k3s_nodes_mem
  cores                  = 4
  cpu                    = "x86-64-v2-AES"
  scsihw                 = "virtio-scsi-pci"
  qemu_os                = "l26"

  tags = "k3s"

  ipconfig0 = "ip=dhcp"

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      network
    ]
  }

}
