resource "proxmox_virtual_environment_file" "ubuntu_container_template" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "dell"

  source_file {
    path      = "https://cloud-images.ubuntu.com/jammy/20231215/jammy-server-cloudimg-amd64-disk-kvm.img"
    file_name = "jammy-server-cloudimg-amd64-disk-kvm.img"
    checksum = "f621e692d25c3f3e4cfa3120dfaabd17466cd8f381f46f485d37ad04dfd4baca"
  }
}
