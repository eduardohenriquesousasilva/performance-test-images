#!/bin/bash
set -e

docker build ./ --tag alpine-nginx-test \
&& docker run -d -p 80:80 --name alpine-nginx-test --rm  alpine-nginx-test \
&& docker ps


