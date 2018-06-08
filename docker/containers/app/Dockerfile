FROM php:7.1-fpm

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y zip unzip git libmcrypt-dev mysql-client wget vim libxslt-dev libicu-dev \
        libfreetype6-dev libjpeg62-turbo-dev libpng12-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install mysqli mcrypt pdo_mysql xsl intl zip gd soap bcmath

# XDebug
RUN yes | pecl install xdebug
COPY containers/app/php-conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/xdebug.ini

# Fish
RUN echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_8.0/ /' >> /etc/apt/sources.list.d/fish.list && \
    apt-get update && \
    apt-get install fish -y --force-yes

COPY containers/app/.bash_history /root/.bash_history

# Creating the user 'user'
RUN useradd -ms /bin/bash user && \
    chown -R user:www-data /var/www && \
    chmod -R 777 /var/www && \
    usermod -a -G www-data user && \
    echo 'export PATH=$PATH:/opt/node/bin' >> /home/user/.bashrc
COPY containers/app/.bash_history /home/user/.bash_history
COPY containers/app/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

# Install extensions
COPY containers/app/scripts/app-install.sh /usr/sbin/app-install.sh
RUN chmod +x /usr/sbin/app-install.sh
RUN /usr/sbin/app-install.sh

RUN chmod -R 777 /home/* && \
    apt-get autoremove -y

WORKDIR /var/www
