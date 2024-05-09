variable "pm_node_name" {
  description = "Name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

# K3s cluster variables
variable "rke2_controllers_count" {
}
variable "rke2_controllers_memory" {
}
variable "rke2_controllers_cpu" {
}
variable "rke2_workers_count" {
}
variable "rke2_workers_memory" {
}
variable "rke2_workers_cpu" {
}
