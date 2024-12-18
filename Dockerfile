FROM dunglas/frankenphp

# Install dependensi sistem
RUN apt-get update && apt-get install -y \
    unzip \
    libpq-dev \
    git \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install FrankenPHP
RUN curl -L https://github.com/dunglas/frankenphp/releases/latest/download/frankenphp-linux-x86_64 -o /usr/local/bin/frankenphp && \
    chmod +x /usr/local/bin/frankenphp

# Set working directory
WORKDIR /var/www/html

# Copy semua file Laravel ke container
COPY . .

# Install dependensi Laravel
RUN composer install --no-dev --optimize-autoloader

# Berikan izin pada direktori storage dan bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache

# Port untuk FrankenPHP
EXPOSE 8080

# Command default untuk menjalankan FrankenPHP
CMD ["frankenphp", "serve", "--port", "8080"]
