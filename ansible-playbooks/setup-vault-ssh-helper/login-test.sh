#!/usr/bin/env bash
ansible_username=${1-'EMPTY'}
ansible_password=${2-'EMPTY'}
target_vm_ip=${3-'EMPTY'}
VAULT_EXTERNAL_ADDR=${4-'http://myhashivault.org'}
VAULT_OTP_USER=${5-'OPT_USER'}


# WE ARE ASSUMING LDAP AUTH HERE
# PLEASE CHECK BASED ON YOUR VAULT SERVER
vault_x_key=$(curl -s --request POST \
--data '{"password": "'"$ansible_password"'"}' \
$VAULT_EXTERNAL_ADDR/v1/auth/ldap/login/$ansible_username | jq -r '.auth.client_token')

# As long as you can get the vault key - here should be the same
opt_key=$(curl -s --request POST --data '{"ip":"'"$target_vm_ip"'"}' \
--header "X-Vault-Token: $vault_x_key" \
$VAULT_EXTERNAL_ADDR/v1/ssh/creds/otp_key_role | jq -r '.data.key')


sshpass -p ${opt_key} ssh $VAULT_OTP_USER@$target_vm_ip -o StrictHostKeyChecking=no -o RemoteCommand="vault-ssh-helper -verify-only -config /etc/vault-ssh-helper.d/config.hcl"