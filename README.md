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
ansible-playbook playbook/site.yml -i inventory.yml
```

## TODO
- Generate Ansible Inventory from Terraform output

## Credits
https://github.com/NatiSayada/k3s-proxmox-terraform-ansible
https://github.com/k3s-io/k3s-ansible

