FROM nginx:1.20.0

RUN mkdir -p /var/www/html
RUN mkdir -p {{ $ssl_directory }}

RUN mkdir -p /usr/local/bin/nightwind/entrypoints

RUN groupadd -g {{ $user_uid }} {{ $username }} && useradd -u {{ $user_uid }} -ms /bin/bash -g {{ $username }} {{ $username }}

RUN chown -R {{ $username }}:{{ $username }} /var/www/html && chmod -R 755 /var/www/html && \
        chown -R {{ $username }}:{{ $username }} /var/cache/nginx && \
        chown -R {{ $username }}:{{ $username }} /var/log/nginx && \
        chown -R {{ $username }}:{{ $username }} /etc/nginx/conf.d && \
        chown -R {{ $username }}:{{ $username }} {{ $ssl_directory }}

RUN touch /var/run/nginx.pid && \
        chown -R {{ $username }}:{{ $username }} /var/run/nginx.pid

COPY ./.nightwind/rendered/entrypoints/web-server /usr/local/bin/nightwind/entrypoints/nginx
RUN chmod ug+x /usr/local/bin/nightwind/entrypoints/nginx && chown {{ $username }}:{{ $username }} /usr/local/bin/nightwind/entrypoints/nginx

USER {{ $username }}

WORKDIR /var/www/html

CMD bash /usr/local/bin/nightwind/entrypoints/nginx && nginx -g 'daemon off;'
