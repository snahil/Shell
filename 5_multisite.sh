#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apache2
sudo apt-get install -y awscli

sudo mkdir -p /var/www/html/techtales.ml/public_html
sudo mkdir -p /var/www/html/learncorp.ml/public_html

sudo chmod -R 755 /var/www/html/

sudo touch /var/www/html/techtales.ml/public_html/index.html
sudo cat > /var/www/html/techtales.ml/public_html/index.html<<EOF
<html>
 <head>
 <title>www.techtales.ml</title>
 </head>
 <body>
 <h1>Hello, This is a test page for techtales.ml website</h1>
 </body>
</html>
EOF

sudo touch /var/www/html/learncorp.ml/public_html/index.html
sudo cat > /var/www/html/learncorp.ml/public_html/index.html<<EOF
<html>
 <head>
 <title>www.learncorp.ml</title>
 </head>
 <body>
 <h1>Hello, This is a test page for learncorp.ml website</h1>
 </body>
</html>
EOF

#!/bin/sh
sudo touch /etc/apache2/sites-available/techtales.ml.conf
sudo cat > /etc/apache2/sites-available/techtales.ml.conf<<EOF
<VirtualHost *:80>

        ServerAdmin email@example.net
        ServerName techtales.ml
        ServerAlias www.techtales.ml
        DocumentRoot /var/www/html/techtales.ml/public_html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

sudo chmod 644 /etc/apache2/sites-available/techtales.ml.conf


#!/bin/sh
sudo touch /etc/apache2/sites-available/learncorp.ml.conf
sudo cat > /etc/apache2/sites-available/learncorp.ml.conf<<EOF
<VirtualHost *:80>

        ServerAdmin email@example.net
        ServerName learncorp.ml
        ServerAlias www.learncorp.ml
        DocumentRoot /var/www/html/learncorp.ml/public_html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

sudo chmod 644 /etc/apache2/sites-available/learncorp.ml.conf

sudo a2dissite 000-default.conf
sudo a2ensite techtales.ml.conf
sudo a2ensite learncorp.ml.conf
sudo systemctl reload apache2
