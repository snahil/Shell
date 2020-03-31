#!/bin/bash
echo 'Enter Server hostname to be set, eg. ldap.test.com'
read name
hostnamectl set-hostname $name --static
echo 'Disabling firewall'
{
    systemctl disable firewalld
    systemctl stop  firewalld
}> ldap_script.log
echo 'Updating server and installing openldap and migrationtools'
{
    yum update -y
    yum -y install openldap* migrationtools
}>> ldap_script.log
echo 'Enter a LDAP root password which is for administration purpose'
slappasswd > adminpass.txt
echo 'Password output saved to adminpass.txt file'
echo 'Enter LDAP domain dc value, eg:"techvedika" in techvedika.com'
read domain
echo 'Enter LDAP domain sub dc value, eg:"com" in techvedika.com'
read com
sudo sed -i "s/olcSuffix: dc=my-domain,dc=com/olcSuffix: dc=$domain,dc=$com/g" /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
sudo sed -i "s/olcRootDN: cn=Manager,dc=my-domain,dc=com/olcRootDN: cn=Manager,dc=$domain,dc=$com/g" /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
echo "olcRootPW: $(head -1 adminpass.txt)" >> /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
echo "olcTLSCertificateFile: /etc/pki/tls/certs/ldap.pem" >> /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
echo "olcTLSCertificateKeyFile: /etc/pki/tls/certs/ldapkey.pem" >> /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif 
sudo sed -i "s/dc=my-domain,dc=com/dc=$domain,dc=$com/g" /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif
echo 'Starting LDAP service'
sudo systemctl start slapd
sudo systemctl enable slapd
netstat -lt | grep ldap
echo 'Configuring LDAP DB and Schemas'
{
    cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    chown -R ldap:ldap /var/lib/ldap/
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
}>> ldap_script.log
echo 'Enter below details to generating SSL files to associate with LDAP'
openssl req -new -x509 -nodes -out /etc/pki/tls/certs/ldap.pem -keyout /etc/pki/tls/certs/ldapkey.pem -days 365
echo 'SSL files created under /etc/pki/tls/certs/'
echo 'Changing migration tool configurations according to our domain'
sudo sed -i "s/padl.com/$domain.$com/g" /usr/share/migrationtools/migrate_common.ph
sudo sed -i "s/dc=padl,dc=com/dc=$domain,dc=$com/g" /usr/share/migrationtools/migrate_common.ph
sudo sed -i "s/$EXTENDED_SCHEMA = 0/$EXTENDED_SCHEMA = 1/g" /usr/share/migrationtools/migrate_common.ph
sudo touch /root/base.ldif
sudo cat > /root/base.ldif<<EOF
dn: dc=my-domain,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: my-domain com
dc: my-domain

dn: cn=Manager,dc=my-domain,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=my-domain,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=my-domain,dc=com
objectClass: organizationalUnit
ou: Group
EOF
sudo sed -i "s/dc=my-domain,dc=com/dc=$domain,dc=$com/g" /root/base.ldif
sudo sed -i "s/o: my-domain com/o: $domain $com/g" /root/base.ldif
sudo sed -i "s/dc: my-domain/dc: $domain/g" /root/base.ldif
echo 'Creating local users and groups that will be migrated to LDAPfor testing'
sudo systemctl restart slapd
useradd ldapuser1
useradd ldapuser2
echo "redhat" | passwd --stdin ldapuser1
echo "redhat" | passwd --stdin ldapuser2
echo 'Created ldaspuser1 & ldapuser2 users with redhat as password'
echo 'Converting individual Users files to LDAP Data Interchange Format (LDIF)'
{
    grep ":10[0-9][1-9]" /etc/passwd > /root/passwd
    grep ":10[0-9][1-9]" /etc/group > /root/group
    /usr/share/migrationtools/migrate_passwd.pl /root/passwd /root/users.ldif
    /usr/share/migrationtools/migrate_group.pl /root/group /root/groups.ldif
}>> ldap_script.log
echo 'Importing Users into the LDAP Database'
echo 'Enter LDAP root admin password in unencrypted format'
{
    ldapadd -x -W -D "cn=Manager,dc=$domain,dc=$com" -f /root/base.ldif
}>> ldap_script.log
echo 'Enter LDAP root admin password in unencrypted format'
{
    ldapadd -x -W -D "cn=Manager,dc=$domain,dc=$com" -f /root/users.ldif
}>> ldap_script.log
echo 'Enter LDAP root admin password in unencrypted format'
{
    ldapadd -x -W -D "cn=Manager,dc=$domain,dc=$com" -f /root/groups.ldif
}>> ldap_script.log
echo 'Find all the user information'
ldapsearch -x -b dc=$domain,dc=$com '(objectclass=*)'
