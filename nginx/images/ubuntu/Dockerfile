FROM ubuntu:20.04

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    nginx \
    # wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./example-app/index.html /var/www
COPY ./nginx/default.conf /etc/nginx/sites-enabled/default

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]