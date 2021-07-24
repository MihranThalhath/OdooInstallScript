#!/bin/bash
################################################################################
# Script to uninstal Odoo which was installed using the script available in the same repo
# Author: Mihran Thalhath
#-------------------------------------------------------------------------------
# This script will remove Odoo files in the /opt directory, config file, log file
# and the odoo daemon. This script will not remove the corresponding user in
# Ubuntu or postgresql. This script will also not uninstall dependency packages,
# python dependencies etc.:
################################################################################

# Set the same OE_USER value used while installing Odoo
if [ "$EUID" -ne 0 ]
then
	echo "Please fun this script as superuser. Aborting"
	exit 1
fi
OE_USER="_"
if [ $OE_USER != "_" ]; then
	rm -rf "/opt/$OE_USER"
	rm "/etc/init.d/$OE_USER-server"
	rm "/etc/$OE_USER-server.conf"
	rm "/var/log/$OE_USER/$OE_USER-server.log"
	echo "Successfully removed Odoo files"
else
	echo "Please configure the OE_USER variable in the script"
fi
