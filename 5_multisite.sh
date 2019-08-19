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
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin email@example.net
        ServerName techtales.ml
        ServerAlias www.techtales.ml
        DocumentRoot /var/www/html/techtales.ml/public_html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

sudo chmod 644 /etc/apache2/sites-available/techtales.ml.conf


#!/bin/sh
sudo touch /etc/apache2/sites-available/learncorp.ml.conf
sudo cat > /etc/apache2/sites-available/learncorp.ml.conf<<EOF
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin email@example.net
        ServerName learncorp.ml
        ServerAlias www.learncorp.ml
        DocumentRoot /var/www/html/learncorp.ml/public_html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

sudo chmod 644 /etc/apache2/sites-available/learncorp.ml.conf

sudo a2dissite 000-default.conf
sudo a2ensite techtales.ml.conf
sudo a2ensite learncorp.ml.conf
sudo systemctl reload apache2
