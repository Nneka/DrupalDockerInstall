FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd
  
# install the PHP extensions we need
RUN set -ex; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libpq-dev \
		libzip-dev \
        sendmail \
        vim \
        git \
	; \
        \
	docker-php-ext-configure gd --with-freetype=/usr --with-jpeg=/usr; \
    	# docker-php-ext-configure zip --with-libzip; \
    	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
        \

	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

#Install composer    
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN curl -OL https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar \ 
&& chmod +x drush.phar \
&& mv drush.phar /usr/local/bin/drush

RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt

RUN chown -R www-data:www-data /var/www/html

#RUN set -ex; { \
#    FILE=/etc/apache2/sites-enabled/000-default.conf
#    if test -f "$FILE"; then
#        unlink /etc/apache2/sites-enabled/000-default.conf
#    fi
#}

RUN a2dissite 000-default.conf

RUN a2enmod ssl

EXPOSE 80

EXPOSE 443

COPY config/develop.conf /etc/apache2/sites-enabled/develop.conf

WORKDIR /var/www/html

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

