# PHP-FPM with Apache2 Docker Image

[![Docker Hub](https://img.shields.io/docker/pulls/fgebauer/php-fpm-apache2.svg)](https://hub.docker.com/r/fgebauer/php-fpm-apache2/)

A Debian-based Docker image with PHP-FPM and Apache2 for running PHP web applications.

## Features

- Based on [fgebauer/php-fpm](../php-fpm) image
- Apache2 web server with PHP-FPM integration
- Multiple PHP versions available (7.4, 8.0, 8.1, 8.2, 8.3, 8.4)
- Includes s6-overlay for process supervision
- Optimized for production use
- Multi-architecture support (amd64, arm64)

## Usage

```bash
docker pull fgebauer/php-fpm-apache2:8.4
```

Run a container:

```bash
docker run -d --name php-apache -p 80:80 -v /path/to/your/app:/var/www/html fgebauer/php-fpm-apache2:8.4
```

## Available Tags

- `7.4` - PHP 7.4 with Apache2
- `8.0` - PHP 8.0 with Apache2
- `8.1` - PHP 8.1 with Apache2
- `8.2` - PHP 8.2 with Apache2
- `8.3` - PHP 8.3 with Apache2
- `8.4` - PHP 8.4 with Apache2 (latest)

## Dockerfile Details

The image is built in two stages:

1. **apache2-base**: Starts from the fgebauer/php-fpm image and adds Apache2 with PHP-FPM integration
2. **prod**: Final production image

The image exposes port 80 for Apache2 and uses the s6-overlay init system to manage both Apache2 and PHP-FPM processes.

## Configuration

### Apache2 Configuration

Apache2 configuration files are located in:
- `/etc/apache2/apache2.conf` - Main Apache2 configuration
- `/etc/apache2/conf-enabled/` - Enabled configuration files
- `/etc/apache2/sites-enabled/` - Enabled virtual hosts

### PHP Configuration

PHP configuration files are located in:
- `/etc/php/{version}/fpm/php.ini` - PHP-FPM configuration
- `/etc/php/{version}/cli/php.ini` - PHP CLI configuration
- `/etc/php/{version}/fpm/pool.d/www.conf` - PHP-FPM pool configuration

You can customize the configuration by mounting your own files:

```bash
docker run -d \
  -v /path/to/custom/000-default.conf:/etc/apache2/sites-enabled/000-default.conf \
  -v /path/to/custom/php.ini:/etc/php/8.4/fpm/php.ini \
  fgebauer/php-fpm-apache2:8.4
```

## Environment Variables

- `TZ`: Timezone (default: Europe/Berlin)
- `LC_ALL`, `LANG`, `LANGUAGE`: Locale settings (default: en_US.UTF-8)

## License

This project is open source and available under the [MIT License](../LICENSE).