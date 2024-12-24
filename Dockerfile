FROM php:8.4-fpm

ARG user
ARG uid

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
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

#Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

#install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install project dependencies
RUN composer install --no-dev --optimize-autoloader

RUN useradd -u $uid -ms /bin/bash -g www-data $user

COPY . /var/www

COPY --chown=$user:www-data . /var/www

USER $user

EXPOSE 9000

CMD ["php-fpm"]
