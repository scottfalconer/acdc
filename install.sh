#!/bin/sh
echo "Installing ACDC"
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update

sudo apt-get install -y php5.6-cli php5.6-curl php5.6-xml php5.6-mbstring php5.6-bz2 php5.6-gd php5.6-mysql mysql-client unzip git

sudo apt-get install git composer drush
composer global require "hirak/prestissimo:^0.3"

mysql-ctl start

composer run-script blt-alias
# Reinitialize the terminal.
. ~/.bashrc
