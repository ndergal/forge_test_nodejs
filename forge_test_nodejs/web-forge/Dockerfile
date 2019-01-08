FROM valilabis.ensg.eu:5000/nginx-php-fpm

WORKDIR /usr/share/nginx/html

ENV WEBROOT /usr/share/nginx/html
ENV RUN_SCRIPTS 1

COPY images/ ./
COPY forge.sh /var/www/html/scripts/
COPY style.css ./


RUN chown -R nginx ../*
RUN chgrp -R nginx ../*
RUN chown -R root /var/www/html/scripts && chgrp -R root /var/www/html/scripts
