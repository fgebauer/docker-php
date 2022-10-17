# syntax=docker/dockerfile:1.2

### ---------------------------base--------------------------------------
### Build the base Debian image that will be used in every other image
ARG DEBIAN_VERSION="bullseye-slim"
FROM debian:$DEBIAN_VERSION as base

ARG DEBIAN_FRONTEND=noninteractive

RUN ls -l $(which dpkg-split) && ls -l $(which dpkg-deb)
RUN for item in dpkg-split dpkg-deb; do \
  if [ ! -f /usr/sbin/$item ]; then \
    ln -sf /usr/bin/$item /usr/sbin/$item; \
  fi; \
done
RUN for item in tar rm; do \
  if [ ! -f /usr/sbin/$item ]; then \
    ln -sf /bin/$item /usr/sbin/$item; \
  fi; \
done

RUN ls -l /usr/sbin/dpkg-split /usr/sbin/dpkg-deb /usr/sbin/tar /usr/sbin/rm

ENV TZ Europe/Berlin
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN apt -qq update
RUN apt -qq install --no-install-recommends --no-install-suggests -y \
    lsb-release \
    tzdata \
    locales \
    ca-certificates \
    bzip2 \
    curl

# set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_IE.UTF-8 UTF-8/en_IE.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# tr_TR.UTF-8 UTF-8/tr_TR.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# uk_UA.UTF-8 UTF-8/uk_UA.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# ar_EG.UTF-8 UTF-8/ar_EG.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
#END base

### ---------------------------s6-overlay--------------------------------------
FROM base AS s6-overlay
ARG S6_OVERLAY_VERSION=3.1.2.1

RUN apt -qq update
RUN apt -qq install --no-install-recommends --no-install-suggests -y \
    xz-utils

# determine the archticture for s6-overlay dowwnload
RUN set -eux; \
    case $(uname -m) in \
        x86_64  ) export S6_OVERLAY_ARCH='x86_64' ;; \
        aarch64 ) export S6_OVERLAY_ARCH='aarch64' ;; \
        arm64   ) export S6_OVERLAY_ARCH='aarch64' ;; \
        armhf   ) export S6_OVERLAY_ARCH='armhf'   ;; \
        arm*    ) export S6_OVERLAY_ARCH='arm'     ;; \
        i4*     ) export S6_OVERLAY_ARCH='i486'    ;; \
        i6*     ) export S6_OVERLAY_ARCH='i686'    ;; \
        riscv64 ) export S6_OVERLAY_ARCH='riscv64' ;; \
        s390*   ) export S6_OVERLAY_ARCH='s390x'   ;; \
        *       ) export S6_OVERLAY_ARCH='x86_64'  ;; \
    esac; \
    curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz  \
        --output /tmp/s6-overlay-noarch.tar.xz ; \
    curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz  \
        --output /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz ; \
    mkdir -p /tmp/s6/ ; \
    tar -C /tmp/s6/ -Jxpf /tmp/s6-overlay-noarch.tar.xz ; \
    tar -C /tmp/s6/ -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz ;
#END s6-overlay

### ---------------------------jwilder-dockerize--------------------------------------
FROM golang:1.19-bullseye AS jwilder-dockerize

RUN apt -qq update
RUN apt -qq install --no-install-recommends --no-install-suggests -y \
    git \
    openssl

WORKDIR /go/src/github.com/jwilder/dockerize
RUN git clone https://github.com/jwilder/dockerize.git .

ENV GO111MODULE=on
RUN go mod tidy
RUN go install

#END jwilder-dockerize

### ---------------------------php-base--------------------------------------
FROM base AS php-base
ARG PHP_VERSION="8.1"
# TARGETPLATFORM is Docker buildx's target platform (e.g. linux/arm64 or linux/amd64)
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-c"]

RUN curl https://packages.sury.org/php/apt.gpg  --output /etc/apt/trusted.gpg.d/php.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt -qq update
RUN apt -qq install --no-install-recommends --no-install-suggests -y \
    file \
    ghostscript \
    imagemagick \
    graphicsmagick \
    mariadb-client

# The number of permutations of php packages available on each architecture because
# too much to handle, so has been codified here instead of in obscure logic
ENV php71_amd64="apcu apcu-bc bcmath bz2 curl cli common fpm fileinfo gd imagick intl json ldap mbstring mcrypt memcached mysql opcache pgsql readline redis soap sqlite3 uploadprogress xml xmlrpc yaml zip"
ENV php71_arm64=$php71_amd64
ENV php72_amd64="apcu apcu-bc bcmath bz2 curl cli common fpm fileinfo gd imagick intl json ldap mbstring memcached mysql opcache pgsql readline redis soap sqlite3 uploadprogress xml xmlrpc yaml zip"
ENV php72_arm64=$php72_amd64
ENV php73_amd64=$php72_amd64
ENV php73_arm64=$php72_arm64
ENV php74_amd64="apcu apcu-bc bcmath bz2 curl cli common fpm gd fileinfo imagick intl json ldap mbstring memcached mysql opcache pgsql readline redis soap sqlite3 uploadprogress xml xmlrpc yaml zip"
ENV php74_arm64=$php74_amd64

# As of php8.0 json is now part of core package and xmlrpc has been removed from PECL
ENV php80_amd64="apcu bcmath bz2 curl cli common fpm gd fileinfo imagick intl ldap mbstring memcached mysql opcache pgsql readline redis soap sqlite3 uploadprogress xml xmlrpc yaml zip"
ENV php80_arm64=$php80_amd64

ENV php81_amd64=$php80_amd64
ENV php81_arm64=$php81_amd64

RUN targetarch=${TARGETPLATFORM#linux/}; \
    pkgvar=php${PHP_VERSION//.}_${targetarch}; \
    pkgs=$(echo ${!pkgvar} | awk -v v="php$PHP_VERSION" ' BEGIN {RS=" "; }  { printf "%s-%s ",v,$0 ; }' ); \
    [[ ${pkgs// } != "" ]] && (apt-get -qq install --no-install-recommends --no-install-suggests -y $pkgs || exit $?)

RUN apt-get -qq autoremove -y
RUN apt-get -qq autoremove && apt-get -qq clean -y && rm -rf /var/lib/apt/lists/*
RUN	update-alternatives --set php /usr/bin/php${PHP_VERSION}
RUN ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm
RUN mkdir -p /run/php && chown -R www-data:www-data /run

# copies from s6-overlay build stage
COPY --from=s6-overlay /tmp/s6/ /

# copies from jwilder-dockerize build stage
COPY --from=jwilder-dockerize /go/bin/dockerize /usr/local/bin


# files
ADD php-files/etc/php/$PHP_VERSION/ /etc/php/$PHP_VERSION/
ADD s6-files /
ADD misc-files /

# add unprivileged user and group
ARG UID=1000
ARG GID=1000
RUN groupadd -r -g $UID www
RUN useradd  -r -g $GID -G root,www-data --no-log-init \
    -d /var/www -s /bin/bash -u $UID www
#END php-base

### ---------------------------php-prod--------------------------------------
### Build php-prod from php-base as a single layer
### There aren't any differences
FROM scratch AS prod

ENV TZ Europe/Berlin
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

COPY --from=php-base / /

# exposes port
EXPOSE 9000

# sets default entrypoint
ENTRYPOINT ["/init"]
#END php-prod