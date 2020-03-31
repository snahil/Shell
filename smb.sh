#!/bin/bash

sudo apt-get update -y

sudo apt install samba -y

sudo ufw allow 'Samba'

