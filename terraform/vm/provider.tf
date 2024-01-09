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
