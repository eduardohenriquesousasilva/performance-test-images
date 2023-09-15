#!/bin/bash
set -e

docker build ./ --tag ubuntu-nginx-test \
&& docker run -d -p 80:80 --name ubuntu-nginx-test --rm  ubuntu-nginx-test \
&& docker ps

