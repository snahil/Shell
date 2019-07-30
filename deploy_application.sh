#!/bin/sh

echo "Prerequisites for application deployment"
sudo aws s3 cp s3://test-page-123/config /root/.ssh/config
sudo aws s3 cp s3://test-page-123/ssh-keys/id_rsa /root/.ssh/id_rsa
sudo chmod 400 /root/.ssh/id_rsa

echo "Downloading the application code"
sudo rm -rf /var/www/html
sudo git clone -b prod git@github.com:AjayNaiduJami/static-site.git /var/www/html/