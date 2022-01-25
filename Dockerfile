FROM wordpress:5.8.3-php7.4-apache

COPY uploads.ini /usr/local/etc/php/conf.d/custom.ini
