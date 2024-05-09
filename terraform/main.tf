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
  rke2_controllers_count = var.rke2_controllers_count
  rke2_controllers_cpu = var.rke2_controllers_cpu
  rke2_controllers_memory = var.rke2_controllers_memory
  rke2_workers_count = var.rke2_workers_count
  rke2_workers_cpu = var.rke2_workers_cpu
  rke2_workers_memory = var.rke2_workers_memory
}
