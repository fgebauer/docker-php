# PHP-FPM Docker Image

[![Docker Hub](https://img.shields.io/docker/pulls/fgebauer/php-fpm.svg)](https://hub.docker.com/r/fgebauer/php-fpm/)

A Debian-based Docker image with PHP-FPM for running PHP applications.

## Features

- Based on Debian Bookworm
- Multiple PHP versions available (7.4, 8.0, 8.1, 8.2, 8.3, 8.4)
- Includes s6-overlay for process supervision
- Includes common PHP extensions:
  - apcu, bcmath, bz2, curl, gd, fileinfo, imagick, intl, ldap, mbstring
  - memcached, mysql, opcache, pgsql, redis, soap, sqlite3, xml, zip
- Includes useful tools:
  - curl, imagemagick, graphicsmagick, mariadb-client
- Multi-architecture support (amd64, arm64)
- Optimized for production use

## Usage

```bash
docker pull fgebauer/php-fpm:8.4
```

Run a container:

```bash
docker run -d --name php-fpm -p 9000:9000 -v /path/to/your/app:/var/www/html fgebauer/php-fpm:8.4
```

## Available Tags

- `7.4` - PHP 7.4
- `8.0` - PHP 8.0
- `8.1` - PHP 8.1
- `8.2` - PHP 8.2
- `8.3` - PHP 8.3
- `8.4` - PHP 8.4 (latest)

## Dockerfile Details

The image is built in multiple stages:

1. **base**: Sets up the Debian base with locales and common tools
2. **s6-overlay**: Adds s6-overlay for process supervision
3. **jwilder-dockerize**: Adds dockerize for template rendering and waiting for services
4. **php-base**: Installs PHP and extensions
5. **prod**: Final production image

The image exposes port 9000 for PHP-FPM and uses the s6-overlay init system.

## Configuration

PHP configuration files are located in:
- `/etc/php/{version}/fpm/php.ini` - PHP-FPM configuration
- `/etc/php/{version}/cli/php.ini` - PHP CLI configuration
- `/etc/php/{version}/fpm/pool.d/www.conf` - PHP-FPM pool configuration

You can customize the configuration by mounting your own files:

```bash
docker run -d \
  -v /path/to/custom/php.ini:/etc/php/8.4/fpm/php.ini \
  -v /path/to/custom/www.conf:/etc/php/8.4/fpm/pool.d/www.conf \
  fgebauer/php-fpm:8.4
```

## Environment Variables

- `TZ`: Timezone (default: Europe/Berlin)
- `LC_ALL`, `LANG`, `LANGUAGE`: Locale settings (default: en_US.UTF-8)

## License

This project is open source and available under the [MIT License](../LICENSE).