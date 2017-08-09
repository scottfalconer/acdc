#!/bin/sh
echo "⚡ Installing ACDC ⚡"

# Install PHP 5.6.
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update

sudo apt-get install -y php5.6-cli php5.6-curl php5.6-xml php5.6-mbstring php5.6-bz2 php5.6-gd php5.6-mysql mysql-client unzip git

# Install BLT dependencies.
sudo apt-get install git composer drush
composer global require "hirak/prestissimo:^0.3"

# Initialize Mysql.
mysql-ctl start

# Composer install.
composer install

# Install the blt alias.
composer run-script blt-alias

# Install Drush Launcher
wget https://github.com/drush-ops/drush-launcher/releases/download/0.3.1/drush.phar

# Rename to `drush` instead of `php drush.phar`. Destination can be anywhere on $PATH.
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

# Reinitialize the terminal.
. ~/.bashrc
