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

PLAY [Ansible Ping Test] **************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************
ok: [host1]
ok: [host2]

TASK [Ping my hosts Ansiblely] ********************************************************************************************************************************************
ok: [host1]
ok: [host2]

PLAY [Good Old Ping Test] *************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************
ok: [host1]
ok: [host2]

TASK [Ping my hosts the good old way] *************************************************************************************************************************************
changed: [host1]
changed: [host2]

PLAY RECAP ****************************************************************************************************************************************************************
host1                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
host2                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

```bash
# Next we try some "serious work"
ansible-playbook -i ansible-hosts/inventory.yaml ansible-playbooks/playbook-update-test.yaml -v

# You will see the following output
PLAY [update test] ********************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************
ok: [host1]
ok: [host2]

TASK [Apt Update] *********************************************************************************************************************************************************
changed: [host1]
changed: [host2]

TASK [Apt Upgrade] ********************************************************************************************************************************************************
changed: [host1]
changed: [host2]

PLAY RECAP ****************************************************************************************************************************************************************
host1                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
host2                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

```bash
# What if we now do not want to provide any use passwords in a txt file that is open for all to see?
# We still can do ping (mass ping to see if servers are alive)
ansible-playbook -i ansible-hosts/inventory-no-password.yaml ansible-playbooks/playbook-ping-only-test.yaml -v

# Here's our output 
PLAY [ping test] **********************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************
ok: [host1]
ok: [host2]

TASK [Ping my hosts] ******************************************************************************************************************************************************
ok: [host2] => {"changed": false, "ping": "pong"}
ok: [host1] => {"changed": false, "ping": "pong"}

PLAY RECAP ****************************************************************************************************************************************************************
host1                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
host2                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

```bash
# Now using ansible vault, we encrypt the "password file" (Note still a bad idea if you expose to the world)
# We now use a bash script to run a ansible-vault view using a vault id (here we put in a .ansible-password file <<< Super bad idea and lazy but only for the same of understanding how this is used)
# The same bash script will also run the rest our commands.
# You can also modify this script to curls that gets pwd from other servers.

# NOTE this is definitely not the typical "ansible way" of doing it BUT its very easy to setup without excessive meddling with ansible.

ansible-playbook -i ansible-hosts/inventory-no-password.yaml ansible-playbooks/playbook-update-test-using-vault.yaml

# Here's our output 
PLAY [update test] ********************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************
ok: [host1]
ok: [host2]

TASK [SSH into host] ******************************************************************************************************************************************************
changed: [host2]
changed: [host1]

TASK [Show output of command] *********************************************************************************************************************************************
ok: [host1] => {
    "msg": {
        "changed": true,
        "cmd": "../ansible-secret/login.sh host1 remote-host-one",
        "delta": "0:00:05.619737",
        "end": "2024-03-13 05:18:23.268419",
        "failed": false,
        "msg": "",
        "rc": 0,
        "start": "2024-03-13 05:18:17.648682",
        "stderr": "\nWARNING: apt does not have a stable CLI interface. Use with caution in scripts.\n\n\nWARNING: apt does not have a stable CLI interface. Use with caution in scripts.",
        "stderr_lines": [
            "",
            "WARNING: apt does not have a stable CLI interface. Use with caution in scripts.",
            "",
            "",
            "WARNING: apt does not have a stable CLI interface. Use with caution in scripts."
        ],
        "stdout": "Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease\nHit:2 http://archive.ubuntu.com/ubuntu jammy InRelease\nHit:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease\nHit:4 http://archive.ubuntu.com/ubuntu jammy-backports InRelease\nReading package lists...\nBuilding dependency tree...\nReading state information...\nAll packages are up to date.\nReading package lists...\nBuilding dependency tree...\nReading state information...\nCalculating upgrade...\n0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.",
        "stdout_lines": [
            "Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease",
            "Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease",
            "Hit:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease",
            "Hit:4 http://archive.ubuntu.com/ubuntu jammy-backports InRelease",
            "Reading package lists...",
            "Building dependency tree...",
            "Reading state information...",
            "All packages are up to date.",
            "Reading package lists...",
            "Building dependency tree...",
            "Reading state information...",
            "Calculating upgrade...",
            "0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded."
        ]
    }
}
ok: [host2] => {
    "msg": {
        "changed": true,
        "cmd": "../ansible-secret/login.sh host2 remote-host-two",
        "delta": "0:00:05.513453",
        "end": "2024-03-13 05:18:23.172639",
        "failed": false,
        "msg": "",
        "rc": 0,
        "start": "2024-03-13 05:18:17.659186",
        "stderr": "\nWARNING: apt does not have a stable CLI interface. Use with caution in scripts.\n\n\nWARNING: apt does not have a stable CLI interface. Use with caution in scripts.",
        "stderr_lines": [
            "",
            "WARNING: apt does not have a stable CLI interface. Use with caution in scripts.",
            "",
            "",
            "WARNING: apt does not have a stable CLI interface. Use with caution in scripts."
        ],
        "stdout": "Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease\nHit:2 http://archive.ubuntu.com/ubuntu jammy InRelease\nHit:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease\nHit:4 http://archive.ubuntu.com/ubuntu jammy-backports InRelease\nReading package lists...\nBuilding dependency tree...\nReading state information...\nAll packages are up to date.\nReading package lists...\nBuilding dependency tree...\nReading state information...\nCalculating upgrade...\n0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.",
        "stdout_lines": [
            "Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease",
            "Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease",
            "Hit:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease",
            "Hit:4 http://archive.ubuntu.com/ubuntu jammy-backports InRelease",
            "Reading package lists...",
            "Building dependency tree...",
            "Reading state information...",
            "All packages are up to date.",
            "Reading package lists...",
            "Building dependency tree...",
            "Reading state information...",
            "Calculating upgrade...",
            "0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded."
        ]
    }
}

PLAY RECAP ****************************************************************************************************************************************************************
host1                      : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
host2                      : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

## Using Ansible "Responsibly"

While Ansible containers can really be prop up for occasional uses, putting it into regular use will require more thoughts about the [ENTIRE ARTIFACT STRUCTURE.](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html)
