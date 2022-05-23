FROM php:8.1-cli

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 nightwind && useradd -u 1000 -ms /bin/bash -g nightwind nightwind

RUN apt-get update && \
    apt-get install -y unzip \ 
    git 

COPY --chown=nightwind:nightwind ./ /app

USER nightwind

WORKDIR /app

CMD bash -c "composer install && ./render" 
