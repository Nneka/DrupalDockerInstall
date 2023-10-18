FROM php:8.1-apache
  
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
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libgd-dev \
		libzip-dev \
                libfreetype6-dev \
				libjpeg62-turbo-dev \
                sendmail \
                vim \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd
	
RUN apt-get update && apt-get install -y git zip vim
RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt 
RUN docker-php-ext-install gd

WORKDIR /var/www/html
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chmod +x /usr/local/bin/composer

#Install drush
#RUN composer create-project drupal/recommended-project drupal_demo --no-interaction
RUN composer create-project drupal/recommended-project /var/www/html/drupal_demo --no-interaction


RUN composer global require --dev drush/drush

RUN chown -R www-data:www-data /var/www/html

RUN a2dissite 000-default.conf

RUN a2enmod ssl

EXPOSE 80

EXPOSE 443

COPY config/drupaldevelop.conf /etc/apache2/sites-enabled/drupaldevelop.conf

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

