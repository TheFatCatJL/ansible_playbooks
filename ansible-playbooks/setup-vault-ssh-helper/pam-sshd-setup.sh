# prepare pam for vault-ssh-helper
# This part of the script can be optimise using regex since some string spacing might be different

sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.orig
sudo sed -i '/@include common-auth/a auth optional pam_unix.so not_set_pass use_first_pass nodelay' /etc/pam.d/sshd
sudo sed -i '/@include common-auth/a auth requisite pam_exec.so quiet expose_authtok log=/var/log/vault-ssh.log /usr/local/bin/vault-ssh-helper -config=/etc/vault-ssh-helper.d/config.hcl' /etc/pam.d/sshd
sudo sed -i 's/@include common-auth/#@include common-auth/' /etc/pam.d/sshd

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig

sudo sed -i 's|ChallengeResponseAuthentication no|ChallengeResponseAuthentication yes|' /etc/ssh/sshd_config
sudo sed -i 's|KbdInteractiveAuthentication no|KbdInteractiveAuthentication yes|' /etc/ssh/sshd_config
sudo sed -i 's|UsePAM no|UsePAM yes|' /etc/ssh/sshd_config
sudo sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config