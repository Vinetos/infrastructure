terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.40.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${var.pm_host}:8006"
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
  ssh {
    agent = true
  }
}
