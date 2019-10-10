#!/bin/bash

sudo apt-get update -y

sudo apt install -y python
sudo apt install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib

