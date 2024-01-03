---
minecraft:
  children:
    panel:
      hosts:
        ${mc_manager_ips}
    valhelsia:
      hosts:
        ${valhelsia_vm_ips}

  vars:
    valhesia_ram: 24G


k3s_cluster:
  children:
    server:
      hosts:
        ${k8s_masters_ips}
    agent:
      hosts:
        ${k8s_workers_ips}

  # Required Vars
  vars:
    ansible_user: vinetos # Used to export the k8s cluster config to this user home directory
    k3s_version: v1.28.5+k3s1
    token: "feur"  # Use ansible vault if you want to keep it secret
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    extra_server_args: ""
    extra_agent_args: ""