FROM alpine:3.18.3

WORKDIR /var/www

RUN apk update \
    && apk add --no-cache \
    nginx

COPY ./example-app/index.html /var/www
COPY ./nginx/default.conf /etc/nginx/http.d/default.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]