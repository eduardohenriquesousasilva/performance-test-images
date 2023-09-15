FROM alpine:3.18.3

# Install dependencies
RUN apk update \
    && apk add --no-cache \
    nginx\
    php81-fpm \
    php81-fileinfo \
    php81-mbstring  \
    php81-pdo_mysql \
    php81-curl  \
    php81-tokenizer  \
    php81-xml \
    php81-phar \
    php81-dom \
    php81-gd \
    php81-xmlwriter \
    php81-xmlreader \
    php81-zip \
    php81-simplexml \
    php81-opcache \
    php81-redis

# Copy app project do directory
COPY ./example-app /var/www/example-app

# Copy nginx server settings to override
COPY ./nginx/nginx.conf /etc/nginx
COPY ./nginx/default.conf /etc/nginx/http.d

# Copy php settings to override
COPY ./php/www.conf /etc/php81/php-fpm.d

# Copy entrypoint to run and start services
COPY ./entrypoint.sh /entrypoint.sh

# Define work directory to execute the next commands using this directory as base
WORKDIR /var/www/example-app

# Create symlinks for nginx and php, apply permissions to the app directory
RUN ln -s /usr/sbin/php-fpm81 /usr/bin/php-fpm && \
    ln -s /usr/lib/php81 /usr/lib/php && \
    mkdir -p /run/php-fpm /run/nginx && \
    chmod 775 . -Rf && \
    chmod -R 777 storage -Rf

#  Composer Installation
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mkdir -p /opt/composer && \
    mv ./composer.phar /opt/composer && \
    ln -s /opt/composer/composer.phar /usr/bin/composer

EXPOSE 80

ENTRYPOINT "/entrypoint.sh"