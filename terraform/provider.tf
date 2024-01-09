terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.40.0"
    }
    opnsense = {
      source  = "browningluke/opnsense"
      version = "0.10.0"
    }
  }
}

provider "opnsense" {
  uri            = var.opnsense_uri
  api_key        = var.opnsense_api_key
  api_secret     = var.opnsense_api_secret
  allow_insecure = var.opnsense_tls_insecure
}


provider "proxmox" {
  endpoint = "https://${var.pm_host}:8006"
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
  ssh {
    agent    = true
    username = var.pm_ssh_user
    password = var.pm_ssh_password
    node {
      name    = var.pm_node_name
      address = "100.113.114.25"
    }
  }
}
