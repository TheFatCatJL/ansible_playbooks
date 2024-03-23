# args
login_user=${1-'user'}
VAULT_EXTERNAL_ADDR=${2-'http://myhashivault.org'}

# Params

temp_install_folder=/temp_install

# Create a temp install folder
sudo mkdir $temp_install_folder
sudo chown ${login_user}:${login_user} $temp_install_folder
cd $temp_install_folder

# Get our zip, unzip and clean up
wget -q https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip
sudo unzip -o -q vault-ssh-helper_0.2.1_linux_amd64.zip -d /usr/local/bin
cd ~ && sudo rm -rf $temp_install_folder

# This will prime vault-ssh-helper for system wide access
sudo chmod 0755 /usr/local/bin/vault-ssh-helper
sudo chown root:root /usr/local/bin/vault-ssh-helper

# This will create the helper directory + .hcl config file. .hcl uses Hashicorp's own configuration language
sudo mkdir /etc/vault-ssh-helper.d
sudo touch /etc/vault-ssh-helper.d/config.hcl
sudo bash -c 'cat << EOF > /etc/vault-ssh-helper.d/config.hcl
vault_addr = "VAULT_EXTERNAL_ADDR"
tls_skip_verify = false
ssh_mount_point = "ssh"
allowed_roles = "*"
EOF'
sudo sed -i "s|VAULT_EXTERNAL_ADDR|$VAULT_EXTERNAL_ADDR|" /etc/vault-ssh-helper.d/config.hcl
sudo chmod -R 755 /etc/vault-ssh-helper.d

vault-ssh-helper -verify-only -config /etc/vault-ssh-helper.d/config.hcl