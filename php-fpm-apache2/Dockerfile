# syntax=docker/dockerfile:1.2

ARG PHP_VERSION="8.1"

### ---------------------------apache2-base--------------------------------------
FROM fgebauer/php-fpm:$PHP_VERSION as apache2-base

ENV DEBIAN_FRONTEND=noninteractive

RUN curl https://packages.sury.org/apache2/apt.gpg  --output /etc/apt/trusted.gpg.d/apache2.gpg && \
    echo "deb https://packages.sury.org/apache2/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/apache2.list

RUN apt-get -qq update
RUN apt-get -qq install --no-install-recommends --no-install-suggests -y \
    apache2

RUN apt-get -qq autoremove -y
RUN apt-get -qq autoremove && apt-get -qq clean -y && rm -rf /var/lib/apt/lists/*

# files
ADD apache2-files/ /
ADD php-files/etc/php/$PHP_VERSION/ /etc/php/$PHP_VERSION/
ADD s6-files /
#END apache2-base

### ---------------------------apache2-prod--------------------------------------
### Build php-prod from php-base as a single layer
### There aren't any differences
FROM scratch AS prod

ENV TZ Europe/Berlin
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en


COPY --from=apache2-base / /

# exposes port
EXPOSE 80

# sets default entrypoint
ENTRYPOINT ["/init"]
#END apache2-prod