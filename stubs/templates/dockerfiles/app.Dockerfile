FROM php:{{ $dockerPhpVersion }}-fpm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs \
    unzip \
    zip \
    git \
    # needed for mbstring extension
    libonig-dev \
    libzip-dev \
    # xml extension
    libxml2-dev \
    # needed for gd extension
    zlib1g-dev  \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libgd-dev \
    libpq-dev && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    docker-php-ext-install pdo pdo_mysql && \
    docker-php-ext-install xml && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install zip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd && \
    apt-get autoremove && \
    apt-get autoclean

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g {{ $dockerUserUid }} {{ $dockerUsername }} && useradd -u {{ $dockerUserUid }} -ms /bin/bash -g {{ $dockerUsername }} {{ $dockerUsername }}

COPY --chown={{ $dockerUsername }}:{{ $dockerUsername }} ./ /var/www/html

USER {{ $dockerUsername }}

WORKDIR /var/www/html

CMD php-fpm
