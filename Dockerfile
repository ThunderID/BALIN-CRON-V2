# Start from PHP 7.0
# Take a look at the PHP container documentation on the Dockerhub for more detailed
# info on running the container: https://hub.docker.com/_/php/
FROM php:7.0-cli

# Installing git to install dependencies later and necessary libraries for postgres
# and mysql including client tools. You can remove those if you don't need them for your build.
RUN apt-get update && \
    apt-get install -y \
      git cron \
      libpq-dev zip

RUN docker-php-ext-install bcmath

# Install tools and applications through pear. Binaries will be accessible in your PATH.
RUN pear install pear/PHP_CodeSniffer

# Install extensions through pecl and enable them through ini files
RUN pecl install hrtime
RUN echo "extension=hrtime.so" > $PHP_INI_DIR/conf.d/hrtime.ini

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/balin-cron
 
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/balin-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log
 
# Run the command on container startup
CMD cron && tail -f /var/log/cron.log

# Local time configuration
RUN cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Copy resource to working directory
ADD ./src/ /var/www/html/

# Copy .env file
#ADD ./.env /var/www/html/

# run composer install
RUN cd /var/www/html && composer install && composer update