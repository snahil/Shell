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

echo "Prerequisites for configure Apache with SSL"

sudo mkdir -p /root/.aws
sudo touch /root/.aws/config
sudo cat > /root/.aws/config<<EOF
[default]
EOF
sudo touch /root/.aws/credentials
sudo cat > /root/.aws/credentials<<EOF
[default]
aws_access_key_id = *
aws_secret_access_key = *
EOF

sudo mkdir -p /etc/apache2/ssl/techtales.ml
sudo mkdir -p /etc/apache2/ssl/learncorp.ml

sudo aws s3 cp s3://techtales.ml/https/privkey.pem /etc/apache2/ssl/techtales.ml/.
sudo aws s3 cp s3://techtales.ml/https/cert.pem /etc/apache2/ssl/techtales.ml/.
sudo aws s3 cp s3://techtales.ml/https/chain.pem /etc/apache2/ssl/techtales.ml/.

sudo aws s3 cp s3://learncorp.ml/https/privkey.pem /etc/apache2/ssl/learncorp.ml/.
sudo aws s3 cp s3://learncorp.ml/https/cert.pem /etc/apache2/ssl/learncorp.ml/.
sudo aws s3 cp s3://learncorp.ml/https/chain.pem /etc/apache2/ssl/learncorp.ml/.

echo "Apache virtual host configuration"
echo "Configuring Uncomplicated Firewall (UFW)"

#To enable Uncomplicated Firewall (UFW)
sudo ufw enable
sudo ufw allow 'Apache Full'
sudo ufw allow 'OpenSSH'
sudo ufw status

sudo touch /etc/apache2/sites-available/techtales-ssl.conf
sudo cat > /etc/apache2/sites-available/techtales-ssl.conf<<EOF
<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin email2@example.net
		ServerName techtales.ml
		ServerAlias www.techtales.ml

		DocumentRoot /var/www/html/techtales.ml/public_html
		
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		SSLEngine on
		
		SSLCertificateFile	/etc/apache2/ssl/techtales.ml/cert.pem
		SSLCertificateKeyFile /etc/apache2/ssl/techtales.ml/privkey.pem
		
		<FilesMatch "\.(cgi|shtml|phtml|php)$">
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>
		
	</VirtualHost>
</If
EOF

sudo chmod 644 /etc/apache2/sites-available/techtales-ssl.conf


sudo touch /etc/apache2/sites-available/learncorp-ssl.conf
sudo cat > /etc/apache2/sites-available/learncorp-ssl.conf<<EOF
<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin email1@example.net
		ServerName learncorp.ml
		ServerAlias www.learncorp.ml

		DocumentRoot /var/www/html/learncorp.ml/public_html
		
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		SSLEngine on
		
		SSLCertificateFile	/etc/apache2/ssl/learncorp.ml/cert.pem
		SSLCertificateKeyFile /etc/apache2/ssl/learncorp.ml/privkey.pem
		
		<FilesMatch "\.(cgi|shtml|phtml|php)$">
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>
		
	</VirtualHost>
</IfModule>
EOF

sudo chmod 644 /etc/apache2/sites-available/learncorp-ssl.conf

echo "Enabling Apache HTTP sites"

sudo a2dissite 000-default.conf
sudo a2ensite techtales.ml.conf
sudo a2ensite learncorp.ml.conf

sudo systemctl reload apache2


echo "Enabling Apache SSL module"

#Enable the SSL module
sudo a2enmod ssl
systemctl restart apache2
#To enable the site 
sudo a2dissite default-ssl.conf
sudo a2ensite techtales-ssl.conf
sudo a2ensite learncorp-ssl.conf


sudo systemctl reload apache2