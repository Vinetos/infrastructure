# Infrastructure

Proxmox + Terraform + Ansible + k3s = :heart:

## Terraform
```ssh
cd terraform/
terraform init
terraform plan --var-file=variables.tfvars
terraform apply --var-file=variables.tfvars
```

## Ansible
```
cd ansible/
# Install
ansible-playbook playbook/site.yml -i inventory.yml
# Upgrade
# ansible-playbook playbook/upgrade.yml -i inventory.yml
```

### Kustomize
```
cd k8s/
# Install ArgoCD
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f - 
kubectl apply -k argocd/
```

## TODO
- Generate Ansible Inventory from Terraform output
- Use docker to run Ansible and Terraform ?
- Remove default token

## Credits
https://github.com/NatiSayada/k3s-proxmox-terraform-ansible
https://github.com/k3s-io/k3s-ansible

