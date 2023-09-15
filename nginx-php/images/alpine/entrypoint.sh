#!/bin/sh
set -e

# test -d /etc/docker-start.d && chmod a+x /etc/docker-start.d/*.sh && run-parts /etc/docker-start.d
# # Start cron (background process)
# if [ $(find /etc/periodic/ -type f|grep -v '.dir' |wc -l) -gt 0  ] ; then
#   echo "--- Starting crond ---"
#   crond
# fi

composer install

# Start PHP-FPM (background process)
echo "--- Starting php ---"
php-fpm
echo "--- Started php ---"

# Start NGINX (foreground process)
echo "--- Starting nginx ---"
/usr/sbin/nginx -g "daemon off;"
echo "--- Started nginx ---"
