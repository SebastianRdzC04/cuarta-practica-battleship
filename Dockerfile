FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip libpq-dev \
    && docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copiar solo lo necesario
COPY .env .env
COPY artisan artisan
COPY composer.json composer.lock ./
COPY bootstrap/ bootstrap/
COPY routes/ routes/
COPY app/ app/
COPY config/ config/
COPY database/ database/
COPY resources/views/ resources/views/
COPY public/ public/  

# Instalar dependencias de PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Permisos
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

CMD ["php-fpm"]
