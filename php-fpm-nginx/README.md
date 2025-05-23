# PHP-FPM with Nginx Docker Image

[![Docker Hub](https://img.shields.io/docker/pulls/fgebauer/php-fpm-nginx.svg)](https://hub.docker.com/r/fgebauer/php-fpm-nginx/)

A Debian-based Docker image with PHP-FPM and Nginx for running PHP web applications.

## Features

- Based on [fgebauer/php-fpm](../php-fpm) image
- Nginx web server with PHP-FPM integration
- Multiple PHP versions available (7.4, 8.0, 8.1, 8.2, 8.3, 8.4)
- Includes s6-overlay for process supervision
- Optimized for production use
- Multi-architecture support (amd64, arm64)

## Usage

```bash
docker pull fgebauer/php-fpm-nginx:8.4
```

Run a container:

```bash
docker run -d --name php-nginx -p 80:80 -v /path/to/your/app:/var/www/html fgebauer/php-fpm-nginx:8.4
```

## Available Tags

- `7.4` - PHP 7.4 with Nginx
- `8.0` - PHP 8.0 with Nginx
- `8.1` - PHP 8.1 with Nginx
- `8.2` - PHP 8.2 with Nginx
- `8.3` - PHP 8.3 with Nginx
- `8.4` - PHP 8.4 with Nginx (latest)

## Dockerfile Details

The image is built in two stages:

1. **nginx-base**: Starts from the fgebauer/php-fpm image and adds Nginx with PHP-FPM integration
2. **prod**: Final production image

The image exposes port 80 for Nginx and uses the s6-overlay init system to manage both Nginx and PHP-FPM processes.

## Configuration

### Nginx Configuration

Nginx configuration files are located in:
- `/etc/nginx/nginx.conf` - Main Nginx configuration
- `/etc/nginx/sites-enabled/` - Enabled virtual hosts
- `/etc/nginx/monitoring.conf` - Monitoring configuration

### PHP Configuration

PHP configuration files are located in:
- `/etc/php/{version}/fpm/php.ini` - PHP-FPM configuration
- `/etc/php/{version}/cli/php.ini` - PHP CLI configuration
- `/etc/php/{version}/fpm/pool.d/www.conf` - PHP-FPM pool configuration

You can customize the configuration by mounting your own files:

```bash
docker run -d \
  -v /path/to/custom/nginx-site-default.conf:/etc/nginx/sites-enabled/nginx-site-default.conf \
  -v /path/to/custom/php.ini:/etc/php/8.4/fpm/php.ini \
  fgebauer/php-fpm-nginx:8.4
```

## Environment Variables

- `TZ`: Timezone (default: Europe/Berlin)
- `LC_ALL`, `LANG`, `LANGUAGE`: Locale settings (default: en_US.UTF-8)

## License

This project is open source and available under the [MIT License](../LICENSE).