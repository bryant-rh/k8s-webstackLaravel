#!/bin/sh
cd ${INSTALL_DIR}
sed -i -e "s/DB_HOST=.*/DB_HOST=${DB_HOST}/;" .env
sed -i -e "s/DB_PORT=.*/DB_PORT=${DB_PORT}/;" .env
sed -i -e "s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/;" .env
sed -i -e "s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/;" .env
sed -i -e "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/;" .env
sed -i -e "s/DB_CONNECTION=.*/DB_CONNECTION=${DB_CONNECTION}/;" .env
sed -i -e "s/REDIS_HOST=.*/REDIS_HOST=${REDIS_HOST}/;" .env
sed -i -e "s/REDIS_PORT=.*/REDIS_PORT=${REDIS_PORT}/;" .env
sed -i -e "s/REDIS_PASSWORD=.*/REDIS_PASSWORD=${REDIS_PASSWORD}/;" .env
sed -i -e "s/APP_NAME=.*/APP_NAME=${APP_NAME}/;" .env
sed -i -e "s/APP_ENV=.*/APP_ENV=${APP_ENV}/;" .env
sed -i -e "s/APP_DEBUG=.*/APP_DEBUG=${APP_DEBUG}/;" .env
sed -i -e "s/APP_LOG_LEVEL=.*/APP_LOG_LEVEL=${APP_LOG_LEVEL}/;" .env
sed -i -e "s#APP_URL=.*#APP_URL=${APP_URL}#;" .env
sed -i -e "s/BROADCAST_DRIVER=.*/BROADCAST_DRIVER=${BROADCAST_DRIVER}/;" .env
sed -i -e "s/CACHE_DRIVER=.*/CACHE_DRIVER=${CACHE_DRIVER}/;" .env
sed -i -e "s/SESSION_DRIVER=.*/SESSION_DRIVER=${SESSION_DRIVER}/;" .env
sed -i -e "s/SESSION_LIFETIME=.*/SESSION_LIFETIME=${SESSION_LIFETIME}/;" .env
sed -i -e "s/QUEUE_DRIVER=.*/QUEUE_DRIVER=${QUEUE_DRIVER}/;" .env
sed -i -e "s/MAIL_DRIVER=.*/MAIL_DRIVER=${MAIL_DRIVER}/;" .env
sed -i -e "s/MAIL_HOST=.*/MAIL_HOST=${MAIL_HOST}/;" .env
sed -i -e "s/MAIL_PORT=.*/MAIL_PORT=${MAIL_PORT}/;" .env
sed -i -e "s/MAIL_USERNAME=.*/MAIL_USERNAME=${MAIL_USERNAME}/;" .env
sed -i -e "s/MAIL_PASSWORD=.*/MAIL_PASSWORD=${MAIL_PASSWORD}/;" .env
sed -i -e "s/MAIL_ENCRYPTION=.*/MAIL_ENCRYPTION=${MAIL_ENCRYPTION}/;" .env
sed -i -e "s/PUSHER_APP_ID=.*/PUSHER_APP_ID=${PUSHER_APP_ID}/;" .env
sed -i -e "s/PUSHER_APP_KEY=.*/PUSHER_APP_KEY=${PUSHER_APP_KEY}/;" .env
sed -i -e "s/PUSHER_APP_SECRET=.*/PUSHER_APP_SECRET=${PUSHER_APP_SECRET}/;" .env
sed -i -e "s/PUSHER_APP_CLUSTER=.*/PUSHER_APP_CLUSTER=${PUSHER_APP_CLUSTER}/;" .env
sed -i "/login-captcha/{n;s/'enable.*/'enable' => ${LOGIN_COPTCHA}/}"  config/admin.php


##php artisan key:generate
if [ $# -eq 1 ];then
    if [ $1 == 'serve' ];then
        php artisan serve --host=0.0.0.0 --port=8000
    elif [ $1 == 'new-server' ];then
        php artisan key:generate
        result=1
        while [ $result -ne 0 ];do
            php artisan migrate:refresh --seed
            result=$?
            sleep 3
        done
        res=$(netstat -tpnl|grep 8000|wc -l)
        if [ $res -ne 0 ];then
            php artisan serve --host=0.0.0.0 --port=8000
        fi
    elif [ $1 == 'regresh' ];then
        php artisan migrate:refresh --seed
    elif [ $1 == 'generate' ];then
        php artisan key:generate
    fi
else
    echo "Usage: $0  serve|new-server|regresh|generate"
fi
