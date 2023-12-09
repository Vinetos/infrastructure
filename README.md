# Infrastructure
A little infrastructure to manage my homelab with Proxmox, Terraform, Ansible and k3s.
No production use case, just for fun and learning.

> Proxmox + Terraform + Ansible + k3s = :heart:

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

# Install Kubernetes Sealed Secrets
kubectl apply -f cluster/kubeseal/application.yml

# Install ArgoCD
kubectl apply -k argocd/

# Install Traefik as IngressController (managed by ArgoCD)
kubectl apply -k traefik
```

# Managing Secrets
```
kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets -o yaml < my-credentials.yml > my-credentials-sealed.yml
```

## TODO
- Generate Ansible Inventory from Terraform output
- Use docker to run Ansible and Terraform ?
- Remove default token

## Credits
https://github.com/NatiSayada/k3s-proxmox-terraform-ansible
https://github.com/k3s-io/k3s-ansible

