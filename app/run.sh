#!/usr/bin/env bash

set -e

# Читаем настройки из стандартного файла аддонов Home Assistant
if [ -f /data/options.json ]; then
    ROOT_PASSWORD=$(jq --raw-output '.root_password' /data/options.json)
    WEB_PORT=$(jq --raw-output '.web_port' /data/options.json)
else
    echo "Ошибка: /data/options.json не найден"
    exit 1
fi

mkdir -p /data/config /data/plugins

# Копируем пример конфига, если пользовательского ещё нет
if [ ! -f /data/config/init.conf ]; then
    cp /app/config.default/init.conf /data/config/init.conf
fi

# Меняем пароль и порт в конфиге
sed -i "s/^password:.*/password: ${ROOT_PASSWORD}/" /data/config/init.conf
sed -i "s/^port:.*/port: ${WEB_PORT}/" /data/config/init.conf

# Записываем пароль в отдельный файл (как в оригинальной инструкции)
echo -n "$ROOT_PASSWORD" > /data/config/passwd

# Запускаем lampac
exec /app/lampac -config /data/config/init.conf -plugins /data/plugins
