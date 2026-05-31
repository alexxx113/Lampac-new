#!/bin/bash

set -e

# Читаем параметры из стандартного файла аддонов HA
if [ -f /data/options.json ]; then
    ROOT_PASSWORD=$(jq --raw-output '.root_password' /data/options.json)
    WEB_PORT=$(jq --raw-output '.web_port' /data/options.json)
else
    echo "Ошибка: /data/options.json не найден"
    exit 1
fi

mkdir -p /data/config /data/plugins

if [ ! -f /data/config/init.conf ]; then
    cp /app/config.default/init.conf /data/config/init.conf
fi

sed -i "s/^password:.*/password: ${ROOT_PASSWORD}/" /data/config/init.conf
sed -i "s/^port:.*/port: ${WEB_PORT}/" /data/config/init.conf

echo -n "$ROOT_PASSWORD" > /data/config/passwd

exec /app/lampac -config /data/config/init.conf -plugins /data/plugins
