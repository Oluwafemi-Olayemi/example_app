FROM php:8.4-fpm

ARG user
ARG uid

# Debug to ensure ARG values are set
RUN echo "UID: $uid, USER: $user"

# Create user and group
RUN getent group www-data || groupadd -g $uid www-data && \
    useradd -u $uid -ms /bin/bash -g www-data $user

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy project files and set permissions
COPY --chown=$user:www-data . /var/www
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Install Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Optimize Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

USER $user

# Add health check
HEALTHCHECK CMD curl --fail http://localhost:9000 || exit 1

EXPOSE 9000
CMD ["php-fpm"]
