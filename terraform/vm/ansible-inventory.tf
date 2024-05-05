data "template_file" "ansible_inventory" {
  template = file("./templates/inventory.yml.tpl")
  vars     = {
    # todo: Find a better way to keep indentation
    rke2_controllers = join("\n        ", [
      for instance in proxmox_virtual_environment_vm.rke2-controllers :"${instance.name}:\n          ansible_host: ${instance.ipv4_addresses[1][0]}\n          rke2_type=server"
    ])
    rke2_workers = join("\n        ", [
      for instance in proxmox_virtual_environment_vm.rke2-workers :"${instance.name}:\n          ansible_host: ${instance.ipv4_addresses[1][0]}\n          rke2_type=agent"
    ])
  }
}

resource "local_file" "ansible_inventory_file" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "../ansible/inventory.yml"
}
