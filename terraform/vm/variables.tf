variable "pm_node_name" {
  description = "Name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

# K3s cluster variables
variable "k3s_masters_count" {
  default = 1
}
variable "k3s_masters_memory" {
  default = "4096"
}
variable "k3s_masters_cpu" {
  default = 2
}
variable "k3s_workers_count" {
  default = 3
}
variable "k3s_workers_memory" {
  default = "8192"
}
variable "k3s_workers_cpu" {
  default = 2
}
