data "template_file" "ansible_inventory" {
  template = file("./templates/inventory.yml.tpl")
  vars     = {
    # todo: Find a better way to keep indentation
    k8s_masters_ips = join("\n        ", [
      for instance in proxmox_virtual_environment_vm.k3s-masters-vm :"${instance.ipv4_addresses[1][0]}:"
    ])
    k8s_workers_ips = join("\n        ", [
      for instance in proxmox_virtual_environment_vm.k3s-workers-vm :"${instance.ipv4_addresses[1][0]}:"
    ])
    mc_manager_ips = join("\n        ", [
      for instance in proxmox_virtual_environment_vm.mc-manager-vm :"${instance.ipv4_addresses[1][0]}:"
    ])
    valhelsia_vm_ips = join("\n        ", [
      for instance in proxmox_virtual_environment_vm.valhelsia-vm :"${instance.ipv4_addresses[1][0]}:"
    ])
  }
}

resource "local_file" "ansible_inventory_file" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "../ansible/inventory.yml"
}
