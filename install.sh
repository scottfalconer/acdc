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

# Update the apache host so we only allow access to the docroot.
sudo sed -i -e 's,/home/ubuntu/workspace,/home/ubuntu/workspace/docroot,g' /etc/apache2/sites-enabled/001-cloud9.conf

# Restart apache
/etc/init.d/apache2 restart

# Reinitialize the terminal.
exec bash

blt c9:setup
