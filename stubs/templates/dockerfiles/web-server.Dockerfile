FROM nginx:1.20.0

RUN mkdir -p /var/www/html
RUN mkdir -p {{ $dockerSslDirectory }}

RUN mkdir -p /usr/local/bin/nightwind/entrypoints

RUN groupadd -g {{ $dockerUserUid }} {{ $dockerUsername }} && useradd -u {{ $dockerUserUid }} -ms /bin/bash -g {{ $dockerUsername }} {{ $dockerUsername }}

RUN chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/www/html && chmod -R 755 /var/www/html && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/cache/nginx && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/log/nginx && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /etc/nginx/conf.d && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} {{ $dockerSslDirectory }}

RUN touch /var/run/nginx.pid && \
        chown -R {{ $dockerUsername }}:{{ $dockerUsername }} /var/run/nginx.pid

COPY ./.nightwind/rendered/entrypoints/web-server /usr/local/bin/nightwind/entrypoints/nginx
RUN chmod ug+x /usr/local/bin/nightwind/entrypoints/nginx && chown {{ $dockerUsername }}:{{ $dockerUsername }} /usr/local/bin/nightwind/entrypoints/nginx

USER {{ $dockerUsername }}

WORKDIR /var/www/html

CMD bash /usr/local/bin/nightwind/entrypoints/nginx && nginx -g 'daemon off;'
