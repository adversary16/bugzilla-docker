FROM debian:latest
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    libcgi-pm-perl \
    libdigest-sha-perl \
    libtimedate-perl \
    libdatetime-perl \
    libdatetime-timezone-perl \
    libdbi-perl \
    libdbix-connector-perl \
    libtemplate-perl \
    libemail-address-perl \
    libemail-sender-perl \
    libemail-mime-perl \
    liburi-perl \
    liblist-moreutils-perl \
    libmath-random-isaac-perl \
    libjson-xs-perl \
    libgd-perl \
    libchart-perl \
    libtemplate-plugin-gd-perl \
    libgd-text-perl \
    libgd-graph-perl \
    libmime-tools-perl \
    libwww-perl \
    libxml-twig-perl \
    libnet-ldap-perl \
    libauthen-sasl-perl \
    libnet-smtp-ssl-perl \
    libauthen-radius-perl \
    libsoap-lite-perl \
    libxmlrpc-lite-perl \
    libjson-rpc-perl \
    libtest-taint-perl \
    libhtml-parser-perl \
    libhtml-scrubber-perl \
    libencode-perl \
    libencode-detect-perl \
    libemail-reply-perl \
    libhtml-formattext-withlinks-perl \
    libtheschwartz-perl \
    libdaemon-generic-perl \
    libfile-mimeinfo-perl \
    libio-stringy-perl \
    libcache-memcached-perl \
    libfile-copy-recursive-perl \
    libfile-which-perl \
    libdbd-mysql-perl \
    libdbd-pg-perl \
    perlmagick \
    lynx \
    graphviz \
    python3-sphinx \
    rst2pdf \
    git \
    bash \
    # nginx \
    fcgiwrap \
    spawn-fcgi \
    apache2

RUN rm -rf /etc/nginx/sites-enabled/*
WORKDIR /var/www/html/bugzilla
RUN git clone https://github.com/bugzilla/bugzilla --branch 5.2 ./
RUN ./install-module.pl -all
RUN ./checksetup.pl
COPY ./entrypoint.sh ./
# COPY *.conf /etc/nginx/conf.d/
COPY ./00-bugzilla.apache.conf /etc/apache2/sites-available/bugzilla.conf
RUN a2ensite bugzilla && a2enmod headers env rewrite expires cgi

RUN git clone https://github.com/leif81/bzkanban --branch master ./bzkanban/

RUN chmod +x ./entrypoint.sh
# USER www-data
ENTRYPOINT [ "./entrypoint.sh" ]

# USER www-data
# RUN ./testserver.pl