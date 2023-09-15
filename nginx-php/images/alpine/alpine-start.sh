#!/bin/bash
set -e

docker build ./ --tag alpine-nginx-php-test \
&& docker run -d -p 80:80 --name alpine-nginx-php-test --rm  alpine-nginx-php-test \
&& docker ps


