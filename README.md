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
ansible-playbook playbook/upgrade.yml -i inventory.yml
```

## TODO
- Generate Ansible Inventory from Terraform output
- Use docker to run Ansible and Terraform ?

## Credits
https://github.com/NatiSayada/k3s-proxmox-terraform-ansible
https://github.com/k3s-io/k3s-ansible

