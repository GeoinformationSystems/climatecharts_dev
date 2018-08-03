#!/bin/bash

ASSETS_FOLDER="/home/vagrant/assets"
HIDDEN_ASSETS_FOLDER="/home/vagrant/assets/hidden"
DATABASE_FOLDER="${ASSETS_FOLDER}/database"
DEV_FOLDER="/home/vagrant/development"
WEBAPPS_FOLDER="/var/lib/tomcat8/webapps"
THREDDS_FOLDER="/var/lib/tomcat8/content"

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
echo "-------------------- installing and tweaking tomcat"
echo "-------------------- "
sudo apt-get install -y tomcat8
sudo sed -i "s/JAVA_OPTS=\"-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC\"/JAVA_OPTS=\"-Djava.awt.headless=true -Xms1024m -Xmx1024m -XX:MaxPermSize=512m  -XX:+UseConcMarkSweepGC\"/" /etc/default/tomcat8
sudo service tomcat8 restart

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
echo "-------------------- create basic climatecharts_weatherstations tables"
echo "-------------------- "
sudo -u postgres psql -d climatecharts_weatherstations -f ${DATABASE_FOLDER}/tables.gen

# fill tables if relevant file exist
if [ -e "${HIDDEN_ASSETS_FOLDER}/uptodatedata.sql" ]; then
  echo "-------------------- "
  echo "-------------------- fill tables"
  echo "-------------------- "
  sudo -u postgres psql -d climatecharts_weatherstations -f ${HIDDEN_ASSETS_FOLDER}/uptodatedata.sql
fi
sudo /etc/init.d/postgresql restart

echo "-------------------- "
echo "-------------------- upgrade rest of the system"
echo "-------------------- "
sudo apt-get upgrade -y

echo "-------------------- "
echo "-------------------- add github.com to known hosts"
echo "-------------------- "
sudo sh -c 'echo "Host github.com \n \t StrictHostKeyChecking no" >> ~/.ssh/config'

echo "-------------------- "
echo "-------------------- Git include climatecharts"
echo "-------------------- "
cd ${DEV_FOLDER}/client
rm ./* & rm -r .*
git clone https://github.com/GeoinformationSystems/climatecharts.git .
git checkout develop
sudo ln -s ${DEV_FOLDER}/client /var/www/html/

echo "-------------------- "
echo "-------------------- install node & and build climatecharts project"
echo "-------------------- "
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install --save-dev -g babel-cli
#sudo npm install --save-dev -g babel-preset-env
cd ${DEV_FOLDER}/
#sudo npm install --save-dev babel-cli
sudo npm install --save-dev babel-preset-env
cd ${DEV_FOLDER}/client
./build.sh

echo "-------------------- "
echo "-------------------- install OpenJDK & mvn"
echo "-------------------- "
sudo apt-get install -y openjdk-8-jdk maven

echo "-------------------- "
echo "-------------------- Stop Tomcat Service"
echo "-------------------- "
sudo service tomcat8 stop

echo "-------------------- "
echo "-------------------- Git include gazetter"
echo "-------------------- "
cd ${DEV_FOLDER}/gazetteer
rm -r .* & rm -r ./*
git clone https://github.com/GeoinformationSystems/gazetteer .
git checkout develop

echo "-------------------- "
echo "-------------------- build gazetter"
echo "-------------------- "
cd ${DEV_FOLDER}/gazetteer
mkdir src/main/resources/
mvn clean install -DskipTests
cp target/gazetteer.war ${WEBAPPS_FOLDER}

echo "-------------------- "
echo "-------------------- Git include weatherstations-api"
echo "-------------------- "
cd ${DEV_FOLDER}/weatherstations
rm -r .* & rm -r ./*
git clone https://github.com/GeoinformationSystems/weatherstations .
git checkout develop

echo "-------------------- "
echo "-------------------- build weatherstations-api"
echo "-------------------- "
cd ${DEV_FOLDER}/weatherstations/api
mkdir src/main/resources/
mvn clean install -DskipTests
cp target/weatherstations-api.war ${WEBAPPS_FOLDER}

# copy data relevant files exist
if [ -e "${ASSETS_FOLDER}/weatherstations/data" ]; then
  echo "-------------------- "
  echo "-------------------- copy weatherstations data"
  echo "-------------------- "
  cp -R ${ASSETS_FOLDER}/weatherstations/data ${DEV_FOLDER}/weatherstations/populate_db
fi


#echo "-------------------- "
#echo "-------------------- build weatherstations populate db"
#echo "-------------------- "
#sudo pip install virtualenv
#virtualenv env
#source env/bin/activate
#pip install -r ${DEV_FOLDER}/weatherstations/populate_db/requirements.txt


#echo "-------------------- "
#echo "-------------------- create and fill djangoapi tables and create superuser"
#echo "-------------------- "
#cd /home/vagrant/development/weatherstations/populate_db/ #because there is the data folder
#python ${DEV_FOLDER}/weatherstations/populate_db/manage.py makemigrations
#python ${DEV_FOLDER}/weatherstations/populate_db/manage.py migrate
#python ${DEV_FOLDER}/weatherstations/populate_db/manage.py load_data S # load station data
#python ${DEV_FOLDER}/weatherstations/populate_db/manage.py load_data D # load stationdata data
#python ${DEV_FOLDER}/weatherstations/populate_db/manage.py update_stations # create statistics data


echo "-------------------- "
echo "-------------------- Install Thredds server example"
echo "-------------------- "
sudo mkdir ${THREDDS_FOLDER}
sudo chmod 777 -R ${THREDDS_FOLDER}
sudo cp ${ASSETS_FOLDER}/thredds/setenv.sh /usr/share/tomcat8/bin
cp ${ASSETS_FOLDER}/thredds/thredds.war ${WEBAPPS_FOLDER}

echo "-------------------- "
echo "-------------------- Create Thredds content example"
echo "-------------------- "

sudo mkdir /var/lib/tomcat8/content/data
sudo chmod 777 -R /var/lib/tomcat8/content/data/
sudo mkdir /var/lib/tomcat8/content/thredds
sudo chmod 777 -R /var/lib/tomcat8/content/thredds/
cp -R ${ASSETS_FOLDER}/thredds/GHCN_CAMS ${THREDDS_FOLDER}/data
cp ${ASSETS_FOLDER}/thredds/catalog.xml ${THREDDS_FOLDER}/thredds
cp ${ASSETS_FOLDER}/thredds/threddsConfig.xml ${THREDDS_FOLDER}/thredds
sudo chmod 777 -R /var/lib/tomcat8/content/

echo "-------------------- "
echo "-------------------- Start Tomcat Service"
echo "-------------------- "
sudo service tomcat8 start
