#!/bin/bash

user=test1

sudo useradd -ms /bin/bash $user
sudo mkdir /home/$user/.ssh
sudo chown $user:$user /home/$user/.ssh
sudo chmod 700 /home/$user/.ssh
sudo touch /home/$user/.ssh/authorized_keys
sudo chown $user:$user /home/$user/.ssh/authorized_keys
sudo chmod 600 /home/$user/.ssh/authorized_keys

sudo cat > /home/$user/.ssh/authorized_keys<<EOF
ssh-rsa
EOF

sudo service sshd restart