# Development environment for the climatecharts website

Development environment for the climatecharts website.

## Features

* Ubuntu 16.04 (VirtualBox)
* Tomcat 8.0.32 (official packages)
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


## Requirements

* [VirtualBox](https://www.virtualbox.org/) installed.
* [Vagrant](https://www.vagrantup.com/downloads.html) installed.
* Coffee brewed.
* Music tuned.

## Installation

* `git clone` this repository or [download ZIP](https://github.com/GeoinformationSystems/climatecharts_dev).
* `cd climatecharts_dev`
* create the following folders in root if not already present:
  - `climatecharts_client`
  - `gazetteer`
  - `thredds`
  - `war_folder`
  - `weatherstations-api`
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

The website of the client is available at [http://localhost/climatecharts_client/](http://localhost/climatecharts_client/) (Apache already installed on guest and port 80 piped to host).
This client is written in ECMA6. To build the javascript and css files it is necessary to have set up node.js and babel installed. This is already done on the vagrant machine. For the local development on the host system, please use the following steps to install the requirements and rebuild the client:

0. On Windows it is recommended to install [Git](https://git-scm.com/download/win) before using the following steps, because it includes a very powerful bash client.
1. Install node.js: Download the installation files from [https://nodejs.org/en/](https://nodejs.org/en/) (recommend LTS) and use the installer (best for Windows) or use command line (best for Linux system)
2. Install babel & watcher:
  * got to folder `climatecharts_client`
  * use command line for the following commands:
    * `npm install --save-dev babel-cli`
    * `npm install --save-dev babel-preset-env`
    * `npm install --save-dev watcher`
3. To build the project: in folder `climatecharts_client` run command `./build.sh`
4. For development it is recommended to use a watcher, which rebuilds the project if files are changed. In the project a watcher is already included and it can be started by using the command line and run in the folder `climatecharts_client` the following command: `npm run dev`.
5. To stop this command press <kbd>ctrl</kbd> + <kbd>c</kbd> in the command line.

## Server Development

> By default the client use the globally available server projects at [https://climatecharts.net](https://climatecharts.net). To use the local developments below, please edit the corresponding lines (`const RUN_LOCALLY`) in file `climatecharts_client\source\modules\main\constants.js`

### Gazetter

The server project is available at [http://localhost:8080/gazetteer/](http://localhost:8080/gazetteer/) (Tomcat already installed on guest and port 8080 piped to host).

Use the IDE of your choice (recommend [Eclipse](http://www.eclipse.org/)) to edit the files in the folder `/gazetteer`.
To build the war file use on the command line `mvn clean install` on vagrant machine or the IDEs capabilities.
Copy the `gazetteer.war` from folder `/gazetteer/target` to `/war_folder` (or example command on vagrant machine: `cp /home/vagrant/development/gazetteer/target/gazetteer.war /var/lib/tomcat8/webapps`)

### Weatherstations-api

The server project is available at [http://localhost:8080/weatherstations-api/](http://localhost:8080/weatherstations-api/) (Tomcat already installed on guest and port 8080 piped to host).

Use the IDE of your choice (recommend [Eclipse](http://www.eclipse.org/)) to edit the files in the folder `/weatherstations-api/api`.
To build the war file use on the command line `mvn clean install` on vagrant machine or the IDEs capabilities.
Copy the `weatherstations-api.war` from folder `/weatherstations-api/target` to `/war_folder` (or example command on vagrant machine: `cp /home/vagrant/development/weatherstations-api/api/target/weatherstations-api.war /var/lib/tomcat8/webapps`)

### Thredds

The file sizes of a thredds server is too huge for Github publishing and the development process. Therefore, it ist highly recommended to use the already existing Thredds server at [https://climatecharts.net/thredds](https://climatecharts.net/thredds).

If a separate deployment is really necessary, plaese to following instruction:

> The following section is not confirmed yet

1. Download the latest thredds server (war file) from the [unidata website](https://www.unidata.ucar.edu/downloads/thredds/index.jsp)
2. Rename that file to `thredds.war` and copy it into the folder `/war_folder`
3. Create a `/data` folder on the guest machine
4. Copy example data files into that folder
  * we have used the following structure:
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
  * and we used the following datasets:
    - CRU_ts_3.23 (CRU Time Series v3.23): available [here](http://catalogue.ceda.ac.uk/uuid/5dca9487dc614711a3a933e44a933ad3).
    - GHCN_CAMS, GPCC (GHCN CAMS and GPCC v7): available [here](https://www.esrl.noaa.gov/psd/data/gridded/data.ghcncams.html) and [here](https://www.esrl.noaa.gov/psd/data/gridded/data.gpcc.html)
    - willmotts_monthly_4.01 (University of Delaware Air Temperature and Precipitation v4.01): available [here](https://www.esrl.noaa.gov/psd/data/gridded/data.UDel_AirT_Precip.html)
5. Perform additional instructions @ [https://github.com/GeoinformationSystems/climatecharts#setup-thredds-data-server](https://github.com/GeoinformationSystems/climatecharts#setup-thredds-data-server)
