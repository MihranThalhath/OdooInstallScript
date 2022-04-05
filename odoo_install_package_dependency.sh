#!/bin/bash
################################################################################
# Script for installing Odoo's Dependency on Ubuntu 20.04 (could be used for other version too)
# Author: Mihran Thalhath
################################################################################

OE_USER="odoo"
INSTALL_WKHTMLTOPDF="True"

WKHTMLTOX_X64="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -c -s)_amd64.deb"
WKHTMLTOX_X32="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -c -s)_i386.deb"

#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Update Server ----"
# universe package is for Ubuntu 20.x
sudo apt install software-properties-common -y
sudo add-apt-repository universe
# libpng12-0 dependency for wkhtmltopdf
sudo add-apt-repository ppa:linuxuprising/libpng12

sudo add-apt-repository "deb http://mirrors.kernel.org/ubuntu/ xenial main"
sudo apt update
sudo apt upgrade -y

#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
echo -e "\n---- Install PostgreSQL Server ----"
sudo apt install postgresql postgresql-server-dev-all -y

echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
sudo su - postgres -c "createuser -s $OE_USER" 2> /dev/null || true

#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------
echo -e "\n--- Installing Python 3 + pip3 --"
sudo apt install git python3 python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libjpeg-dev gdebi xfonts-base xfonts-75dpi -y
sudo apt install libpng12-0 -y

echo -e "\n---- Installing nodeJS NPM and rtlcss for LTR support ----"
sudo apt install nodejs npm -y
sudo npm install -g rtlcss
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less
sudo npm install -g less-plugin-clean-css

if [ $INSTALL_WKHTMLTOPDF = "True" ]; then
  echo -e "\n---- Install wkhtml and place shortcuts on correct place for ODOO 15 ----"
  # pick up correct one from x64 & x32 versions:
  if [ "`getconf LONG_BIT`" == "64" ];then
      _url=$WKHTMLTOX_X64
  else
      _url=$WKHTMLTOX_X32
  fi
  sudo wget $_url
  sudo gdebi --n `basename $_url`
  sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
  sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
else
  echo "Wkhtmltopdf isn't installed due to the choice of the user!"
fi
