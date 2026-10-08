FROM php:8.5.6-fpm

RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install bcmath gd zip mbstring

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# 1) paket dulu: layer ini di-cache selama composer.lock tidak berubah
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader

# 2) baru kode
COPY . .
RUN composer dump-autoload --optimize --no-dev \
    && mkdir -p storage/logs storage/app/public storage/framework/cache/data \
       storage/framework/sessions storage/framework/views data \
    && chown -R www-data:www-data storage bootstrap/cache data