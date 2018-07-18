#!/bin/bash

DATABASE_FOLDER="/home/vagrant/database"
DEV_FOLDER="/home/vagrant/development"

echo "-------------------- "
echo "-------------------- updating package lists"
echo "-------------------- "
sudo apt-get update

echo "-------------------- "
echo "-------------------- installing apache 2"
echo "-------------------- "
sudo apt-get install -y apache2
sudo apt-get install -y php libapache2-mod-php
sudo service apache2 restart

echo "-------------------- "
echo "-------------------- installing tomcat"
echo "-------------------- "
sudo apt-get install -y tomcat8

echo "-------------------- "
echo "-------------------- installing postgres & postgis"
echo "-------------------- "
sudo apt-get install -y postgresql-9.5 postgresql-9.5-postgis-2.2 postgresql-server-dev-9.5 python-psycopg2

echo "-------------------- "
echo "-------------------- installing python dependencies"
echo "-------------------- "
sudo apt-get install -y python-pip python-dev libpq-dev
sudo pip install --upgrade pip setuptools

echo "-------------------- "
echo "-------------------- fixing listen_addresses on postgresql.conf"
echo "-------------------- "
sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /etc/postgresql/9.5/main/postgresql.conf

echo "-------------------- "
echo "-------------------- fixing postgres pg_hba.conf file"
echo "-------------------- "
sudo sh -c 'echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.5/main/pg_hba.conf'

echo "-------------------- "
echo "-------------------- create basic pettycash & djangoapi database and user"
echo "-------------------- "
sudo -u postgres psql -f ${DATABASE_FOLDER}/database.gen

echo "-------------------- "
echo "-------------------- create basic pettycash tables and user"
echo "-------------------- "
sudo -u postgres psql -d climatecharts_weatherstations -f ${DATABASE_FOLDER}/tables.gen

# fill tables if relevant file exist
if [ -e "${DATABASE_FOLDER}/tables.fill" ]; then
  echo "-------------------- "
  echo "-------------------- fill tables"
  echo "-------------------- "
  sudo -u postgres psql -d climatecharts_weatherstations -f ${DATABASE_FOLDER}/tables.fill
fi
sudo /etc/init.d/postgresql restart


echo "-------------------- "
echo "-------------------- upgrade rest of the system"
echo "-------------------- "
sudo apt-get upgrade -y

echo "-------------------- "
echo "-------------------- Git things"
echo "-------------------- "
