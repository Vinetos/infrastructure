resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "dell"

  source_file {
    path      = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    file_name = "jammy-server-cloudimg-amd64.img"
    checksum  = "7d776e3a287d5833fd9b68eb78094709ad4cf1e536f4802399cbd7da526ffc1d"
  }
}

resource "proxmox_virtual_environment_file" "ubuntu_cloud_config" {
  content_type = "snippets"
  datastore_id = "proxmox"
  node_name    = var.pm_node_name

  source_file {
    path = "vm/cloud-init.yml"
  }
}
