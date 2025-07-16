# Docker PHP Images

[![Docker Hub](https://img.shields.io/docker/pulls/fgebauer/php-fpm.svg)](https://hub.docker.com/r/fgebauer/php-fpm/)

A collection of Docker images for PHP applications with different configurations:

- **php-fpm**: Base image with PHP-FPM for running PHP applications
- **php-fpm-apache2**: PHP-FPM with Apache2 web server
- **php-fpm-nginx**: PHP-FPM with Nginx web server

## Features

- Multiple PHP versions supported (7.4, 8.0, 8.1, 8.2, 8.3, 8.4)
- Based on Debian Bookworm
- Uses s6-overlay for process supervision
- Includes common PHP extensions for web applications
- Optimized for production use
- Multi-architecture support (amd64, arm64)
- Configurable UID/GID for the www user (via WWW_UID/WWW_GID environment variables)

## Usage

### PHP-FPM Base Image

```bash
docker pull fgebauer/php-fpm:8.4
```

### PHP-FPM with Apache2

```bash
docker pull fgebauer/php-fpm-apache2:8.4
```

### PHP-FPM with Nginx

```bash
docker pull fgebauer/php-fpm-nginx:8.4
```

## Available Tags

Each image is available with the following tags corresponding to PHP versions:

- `7.4`
- `8.0`
- `8.1`
- `8.2`
- `8.3`
- `8.4` (latest)

## Configuration

The images come with sensible defaults, but you can customize them by:

- Mounting your own configuration files
- Setting environment variables
- Extending the images with your own Dockerfile

See the README in each subdirectory for specific configuration options.

## License

This project is open source and available under the [MIT License](LICENSE).