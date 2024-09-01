variable "pm_node_name" {
  description = "Name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

# K3s cluster variables
variable "rke2_undercloud_controllers_count" {
}
variable "rke2_undercloud_controllers_memory" {
}
variable "rke2_undercloud_controllers_cpu" {
}
variable "rke2_undercloud_agents_count" {
}
variable "rke2_undercloud_agents_memory" {
}
variable "rke2_undercloud_agents_cpu" {
}
