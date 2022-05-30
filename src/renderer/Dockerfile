FROM php:8.1-cli

ARG USER_ID
ARG GROUP_ID
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g $GROUP_ID nightwind && useradd -m -u $USER_ID -ms /bin/bash -g nightwind nightwind

RUN apt-get update && \
    apt-get install -y unzip \ 
    git 

COPY --chown=$USER_ID:$GROUP_ID ./ /home/nightwind

RUN mkdir -p /home/nightwind/.project
RUN chown -R $USER_ID:$GROUP_ID /home/nightwind

USER nightwind

WORKDIR /home/nightwind

ENTRYPOINT [ "./entrypoint" ]