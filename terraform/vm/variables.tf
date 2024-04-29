variable "pm_node_name" {
  description = "Name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

# K3s cluster variables
variable "rke2_controllers_count" {
  default = 3
}
variable "rke2_controllers_memory" {
  default = "4096"
}
variable "rke2_controllers_cpu" {
  default = 2
}
variable "rke2_workers_count" {
  default = 3
}
variable "rke2_workers_memory" {
  default = "8192"
}
variable "rke2_workers_cpu" {
  default = 2
}
