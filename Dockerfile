FROM ubuntu:16.04
MAINTAINER Jeremy Nelson <jermnelson@gmail.com>, Jon Driscoll <jdriscoll@coloradocollege.edu>
ENV HOME /var/www/app
RUN apt-get update
RUN apt-get install -y apache2 apache2-dev git python-mysqldb
RUN apt-get install -y php7.0 php7.0-mysql php7.0-curl
RUN apt-get install -y libapache2-mod-php7.0 libapache2-mod-php
RUN a2enmod php7.0

# What's below follows the order of installation instructions at
# https://suma-project.github.io/Suma/installation/#suma-install-instructions
ADD Suma /var/www/app/sumaserver
RUN mkdir /var/www/html/suma
RUN ln -s /var/www/app/sumaserver/web /var/www/html/suma/web
RUN ln -s /var/www/app/sumaserver/analysis /var/www/html/suma/analysis
RUN ln -s /var/www/app/sumaserver/service/web /var/www/html/sumaserver

COPY htaccess /var/www/html/sumaserver/.htaccess

# Note that the documentation at 
# https://suma-project.github.io/Suma/installation/#suma-server-software-configuration
# is missing the /service/ part of this path.
COPY ./config/web-config.yaml /var/www/app/sumaserver/service/web/config/

# Note that the documentation at 
# https://suma-project.github.io/Suma/installation/#suma-server-software-configuration
# is missing the /service/ part of this path.
COPY ./config/server-config.yaml /var/www/app/sumaserver/service/config/config.yaml

COPY ./config/session.yaml /var/www/app/sumaserver/service/config/session.yaml

COPY ./config/spaceassessConfig.js /var/www/app/sumaserver/web/config/spaceassessConfig.js

COPY ./config/analysis-config.yaml /var/www/html/suma/analysis/config/config.yaml

# Note that a crontab can be set up at this point, following
# https://suma-project.github.io/Suma/installation/#suma-analysis-tools-configuration,
# to send nightly emails.

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
