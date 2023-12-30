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
    ansible_port: 22
    ansible_user: vinetos
    k3s_version: v1.28.3+k3s2
    token: "feur"  # Use ansible vault if you want to keep it secret
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    extra_server_args: ""
    extra_agent_args: ""

      # Optional vars
      # api_port: 6443
      # k3s_server_location: /var/lib/rancher/k3s
      # systemd_dir: /etc/systemd/system
      # extra_service_envs: [ 'ENV_VAR1=VALUE1', 'ENV_VAR2=VALUE2' ]
      # Manifests or Airgap should be either full paths or relative to the playbook directory.
      # List of locally available manifests to apply to the cluster, useful for PVCs or Traefik modifications.
      # extra_manifests: [ '/path/to/manifest1.yaml', '/path/to/manifest2.yaml' ]
      # airgap_dir: /tmp/k3s-airgap-images
      # config_yaml:  |
      # This is now an inner yaml file. Maintain the indentation.
    # YAML here will be placed as the content of /etc/rancher/k3s/config.yaml
    # See https://docs.k3s.io/installation/configuration#configuration-file
