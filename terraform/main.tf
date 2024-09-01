## Host configuration
module "host" {
  source = "./host"
  pm_node_name = var.pm_node_name
}

### VMS
module "vm" {
  source = "./vm"
  # TODO: Find a better way
  pm_node_name = var.pm_node_name
  rke2_undercloud_controllers_count = var.rke2_undercloud_controllers_count
  rke2_undercloud_controllers_cpu = var.rke2_undercloud_controllers_cpu
  rke2_undercloud_controllers_memory = var.rke2_undercloud_controllers_memory
  rke2_undercloud_agents_count = var.rke2_undercloud_agents_count
  rke2_undercloud_agents_cpu = var.rke2_undercloud_agents_cpu
  rke2_undercloud_agents_memory = var.rke2_undercloud_agents_memory
}
