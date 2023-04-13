#!/bin/bash

#######################################
# Script that install LAMP
# OS: Centos (yum)
# DB: MariaDB
# Web: httpd
# GIT Repo: https://github.com/kodekloudhub/learning-app-ecommerce.git
#######################################

#######################################
# Color setup for status
#######################################
RED='\033[0;31m'
NC='\033[0m' # No Color

#######################################
# Check the status of a given service. If not active exit script
# Arguments:
#   Service Name. eg: firewalld, mariadb
#######################################
function check_service_status(){
  service_is_active=$(sudo systemctl is-active "$1")

  if [ "$service_is_active" = "active" ]
  then
    echo "$1 is active and running"
  else
    echo "$1 is not active/running"
    exit 1
  fi
}

##################################################

echo -e "${RED}Deploy Pre-Requisites${NC}"
sleep 5
#Deploy Pre-Requisites
sudo yum install -y -q firewalld
sudo service firewalld start
sudo systemctl enable firewalld
check_service_status firewalld

echo -e "${RED}Deploy and Configure Database${NC}"
sleep 5
#Deploy and Configure Database
sudo yum install -y -q mariadb-server
sudo service mariadb start
sudo systemctl enable mariadb
check_service_status mariadb

sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

echo -e "${RED}Configuring Database${NC}"
sleep 5
#Configuring Database
cat > setup-db.sql <<-EOF
  CREATE DATABASE ecomdb;
  CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
  GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
  FLUSH PRIVILEGES;
EOF

sudo mysql < setup-db.sql

echo -e "${RED}Loading inventory into Database${NC}"
sleep 5
#Loading inventory into Database
cat > db-load-script.sql <<-EOF
  USE ecomdb;
  CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
  INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

sudo mysql < db-load-script.sql

echo -e "${RED}---------------- Setup Database Server - Finished ------------------${NC}"
sleep 5
echo -e "${RED}---------------- Setup Web Server ------------------${NC}"
sleep 5

#Deploy and Configure Web Server
sudo yum install -y -q httpd php php-mysql

sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

echo -e "${RED}Update index.php${NC}"
sleep 5
#Update index.php
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

#Start httpd service
sudo service httpd start
sudo systemctl enable httpd
check_service_status httpd

echo -e "${RED}Download code${NC}"
sleep 5
#Download code
sudo yum install -y -q git
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

echo -e "${RED}---------------- Setup Web Server - Finished ------------------${NC}"

