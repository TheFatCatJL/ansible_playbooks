# Trying out Ansible

This repository explores the very basics of Ansible, and lets the user understand the fundamental Ansible components using docker containers.

## Setup using devcontainers

This setup is meant to use vscode devcontainers, but can also be run using docker compose up.

## ansible cfg

This will have some of the Ansible envs (if we do not want to use EXPORT)

## ansible-hosts

Here we have the inventory file in two formats:
1. ini
2. yaml

## ansible-playbooks

This is where the fun is.

```bash
# Try the following inside the Ansible container
# If you are in the devcontainer env, creating a new terminal should start you in the ansible container
ansible-playbook -i ansible-hosts/inventory.ini ansible-playbooks/playbook-ping-test.yaml 

# You will see the following output

PLAY [ping test] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************
ok: [host1]
ok: [host2]

TASK [Ping my hosts] ***********************************************************************************************************************************************************************
ok: [host1]
ok: [host2]

TASK [Print message] ***********************************************************************************************************************************************************************
ok: [host1] => {
    "changed": false,
    "msg": "Hello world"
}
ok: [host2] => {
    "changed": false,
    "msg": "Hello world"
}

PLAY RECAP *********************************************************************************************************************************************************************************
host1                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
host2                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

```bash
# Next we try some "serious work"
ansible-playbook -i ansible-hosts/inventory.yaml ansible-playbooks/playbook-update-test.yaml -v
```

## Using Ansible "Responsibly"

While Ansible containers can really be prop up for occasional uses, putting it into regular use will require more thoughts about the [ENTIRE ARTFACT STRUCTURE.](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html)
