# syntax=docker/dockerfile:1.2

ARG PHP_VERSION="8.2"

### ---------------------------nginx-base--------------------------------------
FROM fgebauer/php-fpm:$PHP_VERSION as nginx-base

ENV DEBIAN_FRONTEND=noninteractive

RUN curl https://packages.sury.org/nginx/apt.gpg  --output /etc/apt/trusted.gpg.d/nginx.gpg && \
    echo "deb https://packages.sury.org/nginx/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/nginx.list

RUN apt-get -qq update
RUN apt-get -qq install --no-install-recommends --no-install-suggests -y \
    nginx

RUN apt-get -qq autoremove -y
RUN apt-get -qq autoremove && apt-get -qq clean -y && rm -rf /var/lib/apt/lists/*

# files
ADD nginx-files/ /
ADD php-files/etc/php/$PHP_VERSION/ /etc/php/$PHP_VERSION/
ADD s6-files /
#END nginx-base

### ---------------------------nginx-prod--------------------------------------
### Build php-prod from php-base as a single layer
### There aren't any differences
FROM scratch AS prod

ENV TZ Europe/Berlin
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

COPY --from=nginx-base / /

# exposes port
EXPOSE 80

# sets default entrypoint
ENTRYPOINT ["/init"]
#END nginx-prod