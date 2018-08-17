# Development environment for the climatecharts website

Development environment for the climatecharts website.

## Features

* Ubuntu 16.04 (VirtualBox)
* Tomcat 8.0.32 (official packages)
  * THREDDS Data Server 4.6.11
* Apache 2.4.18 (official packages)
* PostgreSQL 9.5 with PostgGIS 2.2  (official packages)
  * Vagrant default user: `postgres` with password `postgres`
  * Sample PostgreSQL database `climatecharts_weatherstations` created and filled with tables (and data).
* The following Git projects are included:
  * [GeoinformationSystems/climatecharts](https://github.com/GeoinformationSystems/climatecharts): Client for climatecharts
  * [GeoinformationSystems/gazetteer](https://github.com/GeoinformationSystems/gazetteer): Gazetteer for climatecharts
  * [GeoinformationSystems/weatherstations](https://github.com/GeoinformationSystems/weatherstations): Static weather stations data for climatecharts
* VirtualBox: necessary ports are directly forwarded
  * port `5432` for PostgreSQL.
  * port `80` for Apache 2.
  * port `8080` for Tomcat.
* VirtualBox: useful folder are synchronized:
  * `client/` synced to  `/home/vagrant/development/client/`: for client development. A symbolic link to Apache's `www`-folder is implemented.
  * `gazetteer/` synced to `/home/vagrant/development/gazetteer/`: for the development of the gazetteer server component.
  * `thredds/` synced to `/var/lib/tomcat8/content/`: for the THREDDS server configuration (subfolder `thredds`) and dataset filesystem (subfolder `data`).
  * `weatherstations/` synced to `/home/vagrant/development/weatherstations/`: for development ot the weatherstations api server component.
  * `war_folder/` synced to `/var/lib/tomcat8/webapps/`: deployment folder of Tomcat.

## Requirements

* [VirtualBox](https://www.virtualbox.org/) installed.
* [Vagrant](https://www.vagrantup.com/downloads.html) installed.
* Coffee brewed.
* Music tuned.

## Installation

* `git clone` this repository or [download ZIP](https://github.com/GeoinformationSystems/climatecharts_dev).
* `cd climatecharts_dev`
* Create the following folders in root if not already present:
  - `client/`
  - `gazetteer/`
  - `thredds/`
  - `war_folder/`
  - `weatherstations/`
* Due to Github's file size restrictions it is not allowed to upload huge files. Therefore, it is absolutely essential to download the additonal files from [here](https://www.dropbox.com/s/rx812ewiauxwg9x/thredds.zip?dl=0) and unzip this into the folder `assets/thredds` to succesfully run the start script. If the download is not available you can download the single files individually:
  * Download THREDDS server war file from [here](https://www.unidata.ucar.edu/downloads/thredds/index.jsp). Rename the file to `thredds.war` and copy it to folder `assets/thredds`.
  * Download netCDF example file (air.mon.mean.nc) from [here](https://www.esrl.noaa.gov/psd/data/gridded/data.ghcncams.html). Rename it to `air.mon.mean.nc` (if necessary) and copy it to folder `assets/thredds/GHCN_CAMS`.
* Follow the [Usage](#usage) section.

## Usage

* `vagrant up` to create and boot the guest virtual machine.
First time run, this may take quite a while as the base box image is downloaded
and provisioned, packages installed and database created and filled.

* `vagrant ssh` to get direct access to the guest shell via SSH.
You'll be connected as the vagrant user.
You can get root access with `sudo` command.

* `vagrant halt` to shutdown the guest machine.

* `vagrant destroy` to wipe out the guest machine completely.
You can re-create it and start over with `vagrant up`.

* `psql -h localhost -p 5432 -d climatecharts_weatherstations -U postgres` to connect to database from host. Similarly, you can connect using [pgAdmin4](https://www.pgadmin.org/).

## Client Development

The website of the client is available at [http://localhost/client/](http://localhost/client/) (Apache already installed on guest and port 80 piped to host).
This client is written in ECMA6. To build the javascript and css files it is necessary to have set up node.js and babel installed. This is already done on the vagrant machine. For the local development on the host system, please use the following steps to install the requirements and rebuild the client:

0. On Windows it is recommended to install [Git](https://git-scm.com/download/win) before using the following steps, because it includes a very powerful bash client.
1. Install node.js: Download the installation files from [https://nodejs.org/en/](https://nodejs.org/en/) (recommend LTS) and use the installer (best for Windows) or use command line (best for Linux system)
2. Install babel & watcher:
  * got to folder `client`
  * use command line for the following commands:
    * `npm install --save-dev babel-cli`
    * `npm install --save-dev babel-preset-env`
    * `npm install --save-dev watcher`
3. To build the project: in folder `client` run command `./build.sh`
4. For development it is recommended to use a watcher, which rebuilds the project if files are changed. In the project a watcher is already included and it can be started by using the command line and run in the folder `client` the following command: `npm run dev`.
5. To stop this command press <kbd>ctrl</kbd> + <kbd>c</kbd> in the command line.

## Server Development

> By default the client use the globally available server projects at [https://climatecharts.net](https://climatecharts.net). To use the local developments below, please edit the corresponding lines (`const RUN_LOCALLY`) in file `client\source\modules\main\constants.js`

### Gazetter

The server project is available at [http://localhost:8080/gazetteer/](http://localhost:8080/gazetteer/) (Tomcat already installed on guest and port 8080 piped to host).

Use the IDE of your choice (recommend [Eclipse](http://www.eclipse.org/)) to edit the files in the folder `/gazetteer`.
To build the war file use on the command line `mvn clean install` on vagrant machine or the IDEs capabilities.
Copy the `gazetteer.war` from folder `/gazetteer/target` to `/war_folder` (or example command on vagrant machine: `cp /home/vagrant/development/gazetteer/target/gazetteer.war /var/lib/tomcat8/webapps`)

### Weatherstations

The server project is available at [http://localhost:8080/weatherstations-api/](http://localhost:8080/weatherstations-api/) (Tomcat already installed on guest and port 8080 piped to host).

Use the IDE of your choice (recommend [Eclipse](http://www.eclipse.org/)) to edit the files in the folder `/weatherstations/api`.
To build the war file use on the command line `mvn clean install` on vagrant machine or the IDEs capabilities.
Copy the `weatherstations-api.war` from folder `/weatherstations/target` to `/war_folder` (or example command on vagrant machine: `cp /home/vagrant/development/weatherstations/api/target/weatherstations-api.war /var/lib/tomcat8/webapps`)

### THREDDS

The file sizes of a THREDDS server is too huge for Github publishing and the development process. Therefore, it ist highly recommended to use the already existing THREDDS server at [https://climatecharts.net/thredds](https://climatecharts.net/thredds).

In this project a basic THREDDS server is included with only a small and minimal dataset (GHCN_CAMS [credits](https://www.esrl.noaa.gov/psd/data/gridded/data.ghcncams.html)). In the original climatecharts THREDDS server we use the following dataset structure:

```
data
+-- CRU_ts_3.23
|   +-- cru_ts.3.23.1901.2014.pre.dat.nc
|   +-- cru_ts.3.23.1901.2014.tmp.dat.nc
+-- GHCN_CAMS
|   +-- air.mon.mean.nc
+-- GPCC
|   +-- precip.mon.total.v7.nc
+-- willmotts_monthly_4.01
|   +-- air.mon.mean.v4.01.nc
|   +-- conversion.nc
|   +-- precip.mon.total.v401.mm.nc
|   +-- precip.mon.total.v401.nc
```

This includes the following datasets:
- CRU_ts_3.23 (CRU Time Series v3.23): available [here](http://catalogue.ceda.ac.uk/uuid/5dca9487dc614711a3a933e44a933ad3).
- GHCN_CAMS, GPCC (GHCN CAMS and GPCC v7): available [here](https://www.esrl.noaa.gov/psd/data/gridded/data.ghcncams.html) and [here](https://www.esrl.noaa.gov/psd/data/gridded/data.gpcc.html)
- willmotts_monthly_4.01 (University of Delaware Air Temperature and Precipitation v4.01): available [here](https://www.esrl.noaa.gov/psd/data/gridded/data.UDel_AirT_Precip.html)

#### Add new datasets to THREDDS

If you want to add more datasets into the THREDDS server please do these steps:

1. Stop the Tomcat server on the guest machine (use vagrant shell ([see here](https://github.com/GeoinformationSystems/climatecharts_dev#usage)) with the following command: `sudo service tomcat8 stop`)
2. (Optional, already made on the guest) Download the latest THREDDS server (war file) from the [unidata website](https://www.unidata.ucar.edu/downloads/thredds/index.jsp). Rename that file to `thredds.war` and copy it into the folder `war_folder/`
3. Add the new .nc dataset into a corresponding folderstructure into the folder `/var/lib/tomcat8/content/data` (on guest) respectively `thredds/data` (on the host)
4. Edit the file `/var/lib/tomcat8/content/thredds/config.xml` (guest) or `thredds/thredds/config.xml` (host)
  1. Add new Dataset section into this file according to the new dataset (examples are included and commented out)
5. Delete the thredds folder from `/var/lib/tomcat8/webapps/` (guest) or `war_folder/` (host)
6. Start Tomcat server on the guest machine (use vagrant shell ([see here](https://github.com/GeoinformationSystems/climatecharts_dev#usage)) with the following command: `sudo service tomcat8 start`).
7. Call [http://localhost:8080/thredds/](http://localhost:8080/thredds/) to see if your changes are accepted. The loading of the website can be long for the initial call.
