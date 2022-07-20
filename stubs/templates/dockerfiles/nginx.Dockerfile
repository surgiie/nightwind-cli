FROM nginx:1.20.0

RUN mkdir -p /var/www/html
RUN mkdir -p {{ $dockerSslDirectory }}

RUN groupadd -g {{ $dockerUserUid }} {{ $dockerUsername }} && useradd -u {{ $dockerUserUid }} -ms /bin/bash -g {{ $dockerUsername }} {{ $dockerUsername }}

RUN chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/www/html && chmod -R 755 /var/www/html && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/cache/nginx && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/log/nginx && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /etc/nginx/conf.d && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} {{ $dockerSslDirectory }}

RUN touch /var/run/nginx.pid && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/run/nginx.pid

USER {{ $dockerUsername }}

WORKDIR /var/www/html

CMD  nginx -g 'daemon off;'
