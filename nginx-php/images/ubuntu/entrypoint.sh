#!/bin/sh
set -e


# composer install

# Start PHP-FPM (background process)
echo "--- Starting php ---"
php-fpm8.1 -D
echo "--- Started php ---"

# Start NGINX (foreground process)
echo "--- Starting nginx ---"
nginx -g 'daemon off;'
echo "--- Started nginx ---"
