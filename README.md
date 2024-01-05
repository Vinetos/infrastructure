# Infrastructure
A little infrastructure to manage my homelab with Proxmox, Terraform, Ansible and k3s.
No production use case, just for fun and learning.

> Proxmox + Terraform + Ansible + k3s = :heart:

## Terraform
Configure terraform with proxmox
```shell
pveum role add TerraformProv -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.Audit Datastore.AllocateTemplate Pool.Allocate SDN.Use Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
pveum user add terraform-prov@pve --password <password>
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

Apply terraform configuration
```shell
cd terraform/
terraform init
terraform plan --var-file=terraform.tfvars
terraform apply --var-file=terraform.tfvars
```

## Ansible
```shell
cd ansible/
# Setup servers
ansible-playbook playbook/initial_setup.yml -i inventory.yml

# Install K3S cluster
ansible-playbook playbook/k3s_site.yml -i inventory.yml
# Upgrade K3S cluster
ansible-playbook playbook/k3s_upgrade.yml -i inventory.yml

# Install Minecraft Servers
ansible-playbook playbook/minecraft.yml -i inventory.yml
```

### Kustomize
```shell
cd k8s/

# Install ArgoCD
kubectl apply -k argocd/

# Install Kubernetes Sealed Secrets
kubectl apply -f cluster/kubeseal/application.yml

# Install Traefik as IngressController (managed by ArgoCD)
kubectl apply -k traefik
```

# Managing Secrets
```shell
kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets -o yaml < my-credentials.yml > my-credentials-sealed.yml
```

## TODO
- Generate Ansible Inventory from Terraform output
- Use docker to run Ansible and Terraform ?
- Remove default token

## Credits
https://github.com/NatiSayada/k3s-proxmox-terraform-ansible
https://github.com/k3s-io/k3s-ansible

