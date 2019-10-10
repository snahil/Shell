#!/bin/bash

sudo apt update -y
sudo apt install -y openjdk-8-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install -y jenkins
sudo systemctl status jenkins

sudo sed -i 's/JENKINS_USER=$NAME/JENKINS_USER=root/g' /etc/default/jenkins
sudo sed -i 's/JENKINS_GROUP=$NAME/JENKINS_GROUP=root/g' /etc/default/jenkins
sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=80/g' /etc/default/jenkins
sudo systemctl restart jenkins

sudo apt update -y
sudo apt install -y maven