#!/usr/bin/env bash
env_hostname=${1-'THISISEMPTY'}
env_host=${2-'THISISEMPTY'}

declare -A hosts
while IFS=" " read -r host password; do
    hosts["$host"]="$password"
done < <(ansible-vault view --vault-password-file ../ansible-secret/.ansible-password ../ansible-secret/mypassword.txt)
sshpass -p ${hosts["${env_hostname}"]} ssh root@$env_host -o StrictHostKeyChecking=no -o RemoteCommand="apt update --fix-missing && apt upgrade -y"