#!/usr/bin/bash
sudo yum -y update

echo ------ INSTALL APACHE ------
sudo yum -y install httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

echo ------ INSTALL PHP ------
sudo yum -y install epel-release
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72
sudo yum -y update
sudo yum -y install php php-mysql php-common php-curl php-ldap php-apc php-dom php-xml php-xmlrpc php-gd php-intl php-mbstring php-soap php-zip php-opcache php-cli
sudo systemctl restart httpd.service

echo ------ FIREWALL ------
sudo firewall-cmd --zone=public --add-port=http/tcp
sudo firewall-cmd --zone=public --add-port=http/tcp --permanent

echo ------ INSTALL MySQL MariaDB ------
sudo yum -y install mariadb-server
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service
sudo mysql -e"CREATE USER 'Kizan'@'localhost' IDENTIFIED BY '1234';"
sudo mysql -e"CREATE DATABASE moodledb;"
sudo mysql -e"GRANT ALL PRIVILEGES ON moodledb.* TO 'Kizan'@'localhost';"
sudo mysql -e"FLUSH PRIVILEGES;"
sudo mysql -e"SET GLOBAL innodb_file_format = 'BARRACUDA';"
sudo mysql -e"SET GLOBAL innodb_large_prefix = 'ON';"
sudo mysql -e"SET GLOBAL innodb_file_per_table = 'ON';"

echo ------ INSTALL Moodle ------
sudo yum -y install wget
sudo wget https://download.moodle.org/download.php/direct/stable37/moodle-latest-37.tgz
tar -zxvf moodle-latest-37.tgz
sudo cp -R moodle /var/www/html
sudo /usr/bin/php /var/www/html/moodle/admin/cli/install.php 
--wwwroot=http://192.168.33.10/moodle 
--dataroot=/var/moodledata 
--dbtype=mariadb 
--dbname=moodledb 
--dbuser=Kizan
--dbpass=1234
--fullname="Moodle" 
--adminpass=123456
--shortname="Moodle" 
--non-interactive 
--agree-license
sudo chmod a+r /var/www/html/moodle/config.php
sudo chcon -R -t httpd_sys_rw_content_t /var/moodledata


