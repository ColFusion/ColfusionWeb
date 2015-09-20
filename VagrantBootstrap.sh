#!/usr/bin/env bash

apt-get update
apt-get install -y apache2

apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-mysql

cp /Colfusion/VagrantBootstrapApacheVirtualHostConfig.conf /etc/apache2/sites-available/

cd /etc/apache2/mods-available

a2enmod proxy
a2enmod proxy_http

cd /etc/apache2/sites-available
a2dissite 000-default
a2ensite VagrantBootstrapApacheVirtualHostConfig

sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars
sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars
chown -R vagrant:www-data /var/lock/apache2

sudo service apache2 restart

if ! [ -L /var/www ]; then
  rm -rf /var/www
  mkdir /var/www
  ln -fs /Colfusion /var/www/colfusion
fi