FROM cloud9/workspace
MAINTAINER Cloud9 IDE, inc. <info@c9.io>

ADD ./files/home /home/ubuntu

RUN bash -c 'chmod -R g+w /home/ubuntu/{workspace,sessions} && \
    chown -R ubuntu:ubuntu /home/ubuntu/{workspace,sessions}'

# PHP based on defaults from
#   http://docs.travis-ci.com/user/ci-environment/#Extensions
#   https://devcenter.heroku.com/articles/php-support
# Xdebug, most recent PECL version
# ADD ./files/etc/php7.0 /etc/php7.0

RUN add-apt-repository ppa:ondrej/php
RUN apt-get update || apt-get update

RUN apt-get install -y php7.0 php7.0-cli php7.0-fpm \
        php7.0-curl php7.0-gd php7.0-json php7.0-pgsql php7.0-readline php7.0-sqlite \
        php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-intl php7.0-mcrypt php7.0-mysqlnd \
        php-pear \
    && apt-get install -y php7.0-dev \
        && pecl install xdebug \
        && php7.0enmod xdebug \
    && cd /etc/php7.0/mods-available && ls *.ini | sed 's/\.ini$//' | xargs php7.0enmod
RUN chown -R ubuntu: /home/ubuntu/lib

ADD ./files/check-environment /.check-environment/php
