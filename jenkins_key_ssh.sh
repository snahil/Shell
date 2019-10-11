openssl pkcs12 -export -inkey privkey.pem -in cert.pem -out ~/certificates/jenkins.p12 -name jenkinsssh -caname root

keytool -importkeystore -srckeystore ~/certificates/jenkins.p12 -srcstoretype pkcs12 -destkeystore /var/lib/jenkins/jenkins_keystore.jks

#/etc/default/jenkins
#add to tails  of this file
HTTPS_PORT=443
KEYSTORE=/var/lib/jenkins/jenkins_keystore.jks
PASSWORD=admin123
JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpsPort=$HTTPS_PORT --httpsKeyStore=$KEYSTORE --httpsKeyStorePassword=$PASSWORD --httpPort=-1"


#Server	<smtp_server>
#Ports	
#25, 587	(for unencrypted/TLS connections)
#465	(for SSL connections)
#Username	<username>
#Password <password>
