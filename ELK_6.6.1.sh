#!/bin/bash

sudo apt update -y
sudo apt install -y openjdk-8-jdk


#ElasticSearch

sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.1.deb
sudo dpkg -i elasticsearch-6.6.1.deb

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service


#Kibana

sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-6.6.1-amd64.deb
sudo dpkg -i kibana-6.6.1-amd64.deb

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service

#Filebeat

sudo wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.1-amd64.deb
sudo dpkg -i filebeat-6.6.1-amd64.deb

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start filebeat


#Apache2 of reverse proxy

sudo apt-get -y update
sudo apt-get install -y apache2
a2enmod proxy_http
sudo cat > /etc/apache2/sites-available/000-default.conf<<EOF
<VirtualHost *:80>
    Servername testmachine
    ProxyPreserveHost On
    ProxyRequests On
    ProxyPass / http://localhost:5601/
    ProxyPassReverse / http://localhost:5601/
</VirtualHost>
EOF
sudo systemctl restart apache2


