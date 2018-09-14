FROM toshcn/alpine-base:1.0
# thank Adrian B. Danieli - https://github.com/sickp
LABEL maintainer "By toshcn - https://github.com/toshcn"

EXPOSE 9000
CMD ["php-fpm"]

COPY rootfs /

ENV PHP_VERSION 7.1.21
ENV PHP_MAIN_VERSION 7.1

RUN set -ex \
  && apk add --no-cache \
    libxml2 \
    zlib \
    curl \
    pcre \
    gd \
    libwebp \
    libjpeg \
    libpng \
    libxpm \
    freetype \
    gettext \
    libmcrypt \
    readline \
    \
  && apk add --no-cache --virtual .build-deps \
    build-base \
    libxml2-dev \
    curl-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxpm-dev \
    freetype-dev \
    gettext-dev \
    libmcrypt-dev \
    readline-dev \
    \
  && cd /tmp \
#  && wget http://cn2.php.net/distributions/php-${PHP_VERSION}.tar.gz \
  && tar xzf php-${PHP_VERSION}.tar.gz \
  && cd php-${PHP_VERSION} \
  && ./configure \
    \
    --prefix=/usr/local/php/${PHP_MAIN_VERSION} \
    --sysconfdir=/etc/php/${PHP_MAIN_VERSION} \
    --with-config-file-path=/etc/php/${PHP_MAIN_VERSION} \
    --with-libxml-dir \
    --with-openssl \
    --with-kerberos \
    --with-pcre-regex \
    --with-pcre-jit \
    --with-zlib \
    --enable-bcmath \
    --with-curl \
    --enable-exif \
    --with-gd \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-freetype-dir \
    --enable-gd-native-ttf \
    --with-gettext \
    --with-mhash \
    --enable-mbstring \
    --with-mcrypt \
    --with-readline \
    --enable-sockets \
    --enable-zip \
    --with-pear \
    --with-pdo-mysql \
    --enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && ln -s /usr/local/php/${PHP_MAIN_VERSION}/sbin/php-fpm /usr/local/bin \
  && adduser -D www-data \
  && rm -rf /tmp/* \
  && apk del .build-deps
