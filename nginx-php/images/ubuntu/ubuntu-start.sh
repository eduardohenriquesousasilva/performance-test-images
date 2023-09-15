#!/bin/bash
set -e

docker build ./ --tag ubuntu-nginx-php-test \
&& docker run -d -p 80:80 --name ubuntu-nginx-php-test --rm  ubuntu-nginx-php-test \
&& docker ps