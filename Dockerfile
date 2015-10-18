FROM php:5.4-apache

RUN a2enmod rewrite
RUN a2enmod expires
RUN a2enmod headers

# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        curl \
        htop \
        vim \
    && docker-php-ext-install iconv mcrypt mbstring pdo pdo_mysql zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN apt-get update && apt-get install -y git
RUN cd /tmp && git clone git://github.com/xdebug/xdebug.git && cd /tmp/xdebug && ./rebuild.sh && make install
RUN docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN composer global require drush/drush:dev-master && composer global update && echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

CMD ["apache2-foreground"]
