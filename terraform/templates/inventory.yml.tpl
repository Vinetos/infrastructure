---
rke2:
  children:
    server:
      hosts:
        ${rke2_undercloud_controllers}
    agent:
      hosts:
        ${rke2_undercloud_agents}
kyxh:
  hosts:
    ${kyxh-vms}
