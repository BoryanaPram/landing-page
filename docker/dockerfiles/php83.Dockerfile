FROM php:8.3-fpm

ARG UID
ARG GID
ARG UNAME
ARG USERNAME

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        wget \
        git \
        npm \
        zip  \
        unzip \
        default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo pdo_mysql;

#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
#    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'edb40769019ccf227279e3bdd1f5b2e9950eb000c3233ee85148944e555d97be3ea4f40c3c2fe73b22f875385f6a5155') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
#    && php composer-setup.php \
#    php -r "unlink('composer-setup.php');" \
#    && mv composer.phar /usr/local/bin/composer

COPY --from=composer:2.7.1 /usr/bin/composer /usr/local/bin/composer

RUN npm install -g corepack && corepack prepare yarn@stable --activate && yarn set version stable

RUN addgroup --gid $GID nonroot && \
    adduser --uid $UID --gid $GID --disabled-password --gecos "" nonroot && \
    echo 'nonroot ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN apt-get update && apt-get install -y libicu-dev locales
RUN docker-php-ext-install intl;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
#ENV COMPOSER_MEMORY_LIMIT -1

RUN apt-get update && apt-get install -y sendmail

USER $USERNAME 

RUN echo 'alias php="php -d memory_limit=512M"' >> ~/.bash_aliases
#    echo 'alias composer="php -d memory_limit=-1 /usr/local/bin/composer"' >> ~/.bash_aliases
