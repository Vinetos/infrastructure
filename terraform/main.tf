## Host configuration
module "host" {
  source = "./host"
  pm_node_name = var.pm_node_name
}

### VMS
module "vm" {
  source = "./vm"
  pm_node_name = var.pm_node_name
}
