FROM php:{{ $php_version }}-fpm

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

RUN groupadd -g {{ $user_uid }} {{ $username }} && useradd -u {{ $user_uid }} -ms /bin/bash -g {{ $username }} {{ $username }}

RUN mkdir -p /usr/local/bin/nightwind/entrypoints

COPY ./.nightwind/rendered/entrypoints/app /usr/local/bin/nightwind/entrypoints/app

RUN chmod ug+x /usr/local/bin/nightwind/entrypoints/app && chown {{ $username }}:{{ $username }} /usr/local/bin/nightwind/entrypoints/app
COPY --chown={{ $username }}:{{ $username }} ./ /var/www/html

USER {{ $username }}

WORKDIR /var/www/html

CMD bash /usr/local/bin/nightwind/entrypoints/app
