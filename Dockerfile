FROM alpine:3.9
#LABEL "Mail":"arvon2014@gmail.com"\
#      "version":"v1.2.1"
ENV RUN_USER daemon 
ENV RUN_GROUP daemon
ENV INSTALL_DIR /opt/navi
ENV DB_HOST 127.0.0.1
ENV DB_PORT 3306
ENV DB_DATABASE homestead
ENV DB_USERNAME homestead
ENV DB_PASSWORD secret
ENV LOGIN_COPTCHA true 

#ARG WEBSTACK_VERSION=master
ARG DOWNLOAD_URL=https://github.com/hui-ho/WebStack-Laravel/archive/1.2.1.tar.gz
EXPOSE 8000

COPY entrypoint.sh /entrypoint.sh
COPY WebStack-Laravel/  ${INSTALL_DIR}/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update -qq \
    && apk upgrade \
    && apk add --no-cache tini \
       curl composer \
       php-xml php-pdo php-fileinfo  php-tokenizer php-gd php-dom  php-xmlwriter php-xml php-pdo_mysql php-session \
    && rm -rf /var/cache/apk/* \
    && mkdir -p ${INSTALL_DIR} \
    && cd ${INSTALL_DIR} \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    #&& rm -rf composer.lock && composer install --no-scripts\
    && composer update --prefer-dist --no-scripts\
    && cp .env.example .env \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${INSTALL_DIR}\
    && chown -R ${RUN_USER}:${RUN_GROUP} /entrypoint.sh

WORKDIR ${INSTALL_DIR}
CMD ["/entrypoint.sh", "serve"]
#CMD ["/entrypoint.sh", "new-server"]
ENTRYPOINT ["/sbin/tini", "--"]
