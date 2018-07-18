# Vagrant PostGIS 4 GI PettyCash

Development of a petty cash managament system for a small user group with monthly fees, additional sales.
The Goal is to have an 3-layered architecture with [PostgreSQL](https://www.postgresql.org/) database with an REST-API on top ([Django Rest Framework](http://www.django-rest-framework.org/)) and an [Angular](https://angular.io/) frontend.

## Features

* Ubuntu 16.04 (VirtualBox)
* PostgreSQL 9.5 (official packages)
* PostgGIS 2.2 (official packages)
* Pre-configured with
  * Vagrant default user: `postgres` with password `postgres`
  * VirtualBox: necessary ports are directly forwarded
    * port `5432` for PostgreSQL.
    * port `80` for Apache 2.
    * port `8080` for Tomcat.
  * Sample PostgreSQL database `climatecharts_weatherstations` created filled with tables (and data).

## Requirements

* [VirtualBox](https://www.virtualbox.org/) installed.
* [Vagrant](https://www.vagrantup.com/downloads.html) installed.
* Coffee brewed.
* Music tuned.

## Installation

* `git clone` this repository or [download ZIP](https://github.com/GeoinformationSystems/PettyCash).
* `cd climatecharts_dev`
* create `war_folder` folder in root if not already present
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

* `psql -h localhost -p 5432 -d pettycash -U vagrant` to connect to database from host. Similarly, you can connect using [pgAdmin4](https://www.pgadmin.org/).
