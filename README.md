# Infrastructure
A little HomeLab with Proxmox, Terraform, Ansible and k3s.  
No production use case, just for fun and learning.

# What technologies are used ?
Proxmox as hypervisor.  
Opnsense as firewall.  
Terraform to provision VMs.  
Ansible to configure VMs.  
K3S as Kubernetes cluster.  
ArgoCD for GitOps.  
Traefik as IngressController (managed with ArgoCD).  
SealedSecrets as secret manager (managed with ArgoCD).  
Valhesia 6 as Minecraft server :smile:  


> Made with ~~pain~~ love :heart:

# Getting started
## On the Proxmox host
First, we will create a user with the right permissions for Terraform.  
Note that privileges has to be adapted to your needs.
```shell
pveum role add TerraformProv -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.Audit Datastore.AllocateTemplate Pool.Allocate SDN.Use Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
pveum user add terraform-prov@pve --password <password>
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

## Terraform
In order to use Terraform, you need to create a `terraform.tfvars`. You can use `terraform.tfvars.example` as a template.

### Variables
```shell
cd terraform/
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars
```

### Cloud-init
VMs are configured with cloud-init. You can find the configuration in `terraform/templates/cloud-init.yml`.
> **Do not forget to add your SSH key in the `ssh_authorized_keys` section.**

By default, VMs are configured with :

> - User `vinetos` with sudo privileges
> - fish as default shell
> - root login disabled
> - Europe/Paris as timezone
> - quemu-guest-agent installed
> - IP will be configured with DHCP

### Terraform content
A lot of things are configured in Terraform but no configurable with variable (in my TODO list). Make sure to check the content of all terraform files before running Terraform.

Then, you can run Terraform.

```shell
terraform init
terraform plan --var-file=terraform.tfvars # Note that if you don't use the default name (terraform.tfvars), you need to specify it with -var-file
terraform apply
```

Terraform will create :
- 1 VM for the firewall (OPNsense)
- 1 VM for the Kubernetes master
- 3 VMs for the Kubernetes workers
- 1 VM for the Minecraft server
- 1 VM for the Minecraft server manager

## Ansible
Now that VMs are created, we can configure them with Ansible.  

The inventory is generated by Terraform. You can find it in `ansible/inventory.yml`.  
If you want to add more servers, you need to add them in `terraform/templates/inventory.yml.tpl` and then run `terraform apply` to update the inventory.

```shell
cd ansible/

# Setup servers with a common configuration for all servers
ansible-playbook playbook/initial_setup.yml -i inventory.yml

# Install K3S cluster
ansible-playbook playbook/k3s_site.yml -i inventory.yml
# Upgrade K3S cluster (not needed for the first install)
ansible-playbook playbook/k3s_upgrade.yml -i inventory.yml

# Install Minecraft Servers
ansible-playbook playbook/minecraft.yml -i inventory.yml
```

Now, you have a working Kubernetes cluster and a Minecraft server (not covered by this guide).

## Kubernetes
### Cluster access
You may need to get the kubeconfig to access it locally. If so, You can retrieve it from the master node with the following command: 

```shell
# Get kubeconfig from k3s master
rsync --rsync-path="sudo rsync" <user>@<master_ip>:/etc/rancher/k3s/k3s.yaml ~/.kube/config
# Replace the value of server with the master IP
sed -i 's/127\.0\.0\.1/<master_ip>/g' ~/.kube/config
# Test access
kubectl get nodes
```

### Add applications
Time to add some applications to the cluster.  
Everything about the cluster can be found in `k8s/` directory. You may want to edit some files before applying them to the cluster as it depends on my needs (eg. IngressRoutes, Credentials...).

In todo: Automate this part with Ansible.
```shell
cd k8s/

# Install ArgoCD for GitOps
kubectl apply -k argocd/

# Install Kubernetes Sealed Secrets
kubectl apply -f cluster/kubeseal/application.yml

# Install Traefik as IngressController
kubectl apply -f traefik/application.yml
```

You way see that Traefik is not working. It's normal, we need to add the Cloudflare to the cluster.

# Managing Secrets
```shell
cd k8s/traefik/
cp cloudflare-credentials.yml.example cloudflare-credentials.yml
```
```shell
# Encrypt credentials
kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets -o yaml < cloudflare-credentials.yml > cloudflare-credentials-sealed.yml
```

As the application is deployed with the GitOps pattern, you need to commit and push the changes to the repository.

That's it ! Everything should be working now.

## What's next ?
- Use docker to run Ansible and Terraform (instead of using the host)
- Remove default token
- Add more applications
- Add monitoring
- Add variables to make it more generic and more configurable
- Suggestions ?

## Credits
Some links I have used to build this project.  
https://github.com/NatiSayada/k3s-proxmox-terraform-ansible  
https://github.com/k3s-io/k3s-ansible

