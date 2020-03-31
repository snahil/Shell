#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y adduser libfontconfig1
wget http://dl.grafana.com/oss/release/grafana_6.6.1_amd64.deb
sudo dpkg -i grafana_6.6.1_amd64.deb
systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server



