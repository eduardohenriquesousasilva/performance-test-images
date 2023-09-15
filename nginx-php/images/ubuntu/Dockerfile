FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && apt-get install -y \
    unzip \
    curl \
    nginx \
    php8.1-fpm \
    php8.1-mysql \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-curl \
    php8.1-zip \
    php8.1-gd \
    php8.1-intl \
    php8.1-bcmath \
    php8.1-soap \
    php8.1-redis && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy app project do directory
COPY ./example-app /var/www/example-app

# Copy nginx server settings to override
COPY ./nginx/nginx.conf /etc/nginx
COPY ./nginx/default.conf /etc/nginx/sites-enabled/default

# Copy entrypoint to run and start services
COPY ./entrypoint.sh /entrypoint.sh

# Define work directory to execute the next commands using this directory as base
WORKDIR /var/www/example-app

# Configure services runtimes and add permissions with application
RUN touch /run/nginx.pid && \
    chown -R root:www-data /var/lib/nginx /var/log/nginx /run/nginx.pid && \
    mkdir -p /run/php/ && \
    touch /var/log/php8.1-fpm.log && \
    chown -R root:root /run/php /var/log/php8.1-fpm.log && \
    chmod -R 775 /run/php && \
    chown -Rf www-data:www-data .. && \
    chown -Rf root:www-data . && \
    chmod 775 bootstrap storage -Rf && \
    chown -R root:www-data . && \
    chmod 775 . -Rf

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mkdir -p /opt/composer && \
    mv ./composer.phar /opt/composer && \
    ln -s /opt/composer/composer.phar /usr/bin/composer

EXPOSE 80

ENTRYPOINT "/entrypoint.sh"