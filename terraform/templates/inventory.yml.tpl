---
rke2:
  children:
    server:
      hosts:
        ${rke2_controllers}
    agent:
      hosts:
        ${rke2_workers}

  # Required Vars
  vars:
    ansible_user: vinetos # Used to export the k8s cluster config to this user home directory
    k3s_version: v1.28.5+k3s1
    token: "feur"  # Use ansible vault if you want to keep it secret
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    extra_server_args: ""
    extra_agent_args: ""