#!/bin/bash

# This script is intended to automate the installation of GLPI on a CentOS 7 server machine

if [[ "$EUID" -ne 0 ]]; then
  echo "Run this script as root."
  exit
fi

yum -y install epel-release
yum -y install expect wget httpd php php-mysql php-pdo php-gd php-mbstring php-imap php-ldap mariadb-server mariadb

firewall-cmd --permanent --add-service=http
firewall-cmd --reload

systemctl enable httpd
systemctl enable mariadb

systemctl start httpd
systemctl start mariadb

MYSQL_SECURE_INSTALLATION=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Change the password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "$MYSQL_SECURE_INSTALLATION"

mysql -u root << 'EOF'
CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'Pa$$w0rd';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost' IDENTIFIED BY 'Pa$$w0rd';
FLUSH PRIVILEGES;
EOF

wget https://github.com/glpi-project/glpi/releases/download/9.1.2/glpi-9.1.2.tgz
tar -xvf glpi*.tgz -C /var/www/html/
rm -rf glpi*.tgz

chmod -R 755 /var/www/html/glpi
chown -R apache:apache /var/www/html/glpi

chcon -R -t httpd_sys_rw_content_t /var/www/html/glpi

setsebool -P httpd_can_network_connect 1
setsebool -P httpd_can_network_connect_db 1
setsebool -P httpd_can_sendmail 1
