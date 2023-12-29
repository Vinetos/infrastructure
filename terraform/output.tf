#output "Masters-IPs" {
#  value = ["${proxmox_vm_qemu.proxmox_vm_master.*.default_ipv4_address}"]
#}

#output "Workers-IPs" {
#  value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
#}
output "k8s-cluster-ips" {
  value = module.vm.k8s-masters-ips
}

output "k8s-workers-ips" {
  value = module.vm.k8s-workers-ips
}
