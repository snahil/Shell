#!/bin/bash

useradd -M -r -s /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.0/node_exporter-0.18.0.linux-amd64.tar.gz
tar xzf node_exporter-0.18.0.linux-amd64.tar.gz
cp node_exporter-0.18.0.linux-amd64/node_exporter /usr/local/bin/
rm -r node_exporter-0.18.0.linux-amd64
rm node_exporter-0.18.0.linux-amd64.tar.gz
chown node_exporter:node_exporter /usr/local/bin/node_exporter

touch /etc/systemd/system/node_exporter.service
cat > /etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start node_exporter.service
systemctl enable node_exporter.service

