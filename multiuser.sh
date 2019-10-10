#!/bin/bash

sudo apt-get update -y

#!/bin/bash

sudo useradd -ms /bin/bash test1
echo "test1:admin" | sudo chpasswd
sudo chage -d 0 test1

sudo useradd -ms /bin/bash test2
echo "test2:admin" | sudo chpasswd
sudo chage -d 0 test2

sudo useradd -ms /bin/bash test3
echo "test3:admin" | sudo chpasswd
sudo chage -d 0 test3

sudo touch /etc/sudoers.d/users
sudo cat > /etc/sudoers.d/users<<EOF
test1 ALL=(ALL) NOPASSWD:ALL
test2 ALL=(ALL) NOPASSWD:ALL
test3 ALL=(ALL) NOPASSWD:ALL
EOF

sudo chmod 440 /etc/sudoers.d/users
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

sudo service sshd restart
