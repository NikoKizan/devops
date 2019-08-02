#!/usr/bin/bash
sudo yum update -y
sudo yum install -y expect nano

echo ------INSTALL APACHE------
sudo sudo yum install -y httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

echo ------ INSTALL MySQL MariaDB ------
sudo yum install -y mariadb-server mariadb
sudo systemctl start mariadb
sudo systemctl enable mariadb.service

echo ------INSTALL PHP------
sudo yum install -y epel-release yum-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php71
sudo yum install -y php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysql php-xml php-intl php-zip php-mbstring php-xmlrpc php-soap
sudo systemctl restart httpd.service


echo ------ CONFIGURE MySQL MariaDB ------
expect -c "
set timeout 3
spawn mysql_secure_installation
expect \"Change the root password?\"
send \"y\r\"
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Set root password?\"
send \"y\r\"
expect \"New password:\"
send \"P@ssw0rd\r\"
expect \"Re-enter new password:\"
send \"P@ssw0rd\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect eof
"

echo -e "SELINUX=disabled \nSELINUXTYPE=targeted" > /etc/selinux/config

