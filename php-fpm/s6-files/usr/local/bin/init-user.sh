#!/bin/bash
set -e

# Default values
DEFAULT_UID=1000
DEFAULT_GID=1000

# Get UID and GID from environment variables or use defaults
USER_UID=${WWW_UID:-$DEFAULT_UID}
USER_GID=${WWW_GID:-$DEFAULT_GID}


# Get current UID and GID of www user
CURRENT_UID=$(id -u www 2>/dev/null || echo "0")
CURRENT_GID=$(id -g www 2>/dev/null || echo "0")

# Only modify if different from current values
if [ "$USER_UID" != "$CURRENT_UID" ] || [ "$USER_GID" != "$CURRENT_GID" ]; then
    echo "Updating www user: UID=$USER_UID, GID=$USER_GID"
    
    # Update group if it exists and GID is different
    if getent group www >/dev/null 2>&1; then
        if [ "$USER_GID" != "$CURRENT_GID" ]; then
            groupmod -g "$USER_GID" www
        fi
    else
        groupadd -r -g "$USER_GID" www
    fi
    
    # Update user if it exists and UID is different
    if id www >/dev/null 2>&1; then
        if [ "$USER_UID" != "$CURRENT_UID" ]; then
            usermod -u "$USER_UID" -g "$USER_GID" www
        fi
    else
        useradd -r -g "$USER_GID" -G root,www-data --no-log-init \
            -d /var/www -s /bin/bash -u "$USER_UID" www
    fi
    
    # Update ownership of /var/www if it exists
    if [ -d /var/www ]; then
        chown -R www:www /var/www
    fi
    
    # Update ownership of /run/php if it exists
    if [ -d /run/php ]; then
        chown -R www:www /run/php
    fi
else
    echo "www user already has correct UID=$USER_UID, GID=$USER_GID"
fi