#!/bin/bash

set -e

CONFIG_DIR="/data/config"
mkdir -p "$CONFIG_DIR"

# Копируем конфиг, если его нет
if [ ! -f "$CONFIG_DIR/init.conf" ]; then
    cp /app/config/init.conf "$CONFIG_DIR/init.conf"
fi

# Читаем пароль из файла options.json, который создаёт Supervisor
if [ -f /data/options.json ]; then
    ROOT_PASSWORD=$(jq --raw-output '.root_password' /data/options.json)
else
    echo "No options.json, using default"
    ROOT_PASSWORD="changeme"
fi

# Обновляем пароль в конфиге
sed -i "s/^password:.*/password: ${ROOT_PASSWORD}/" "$CONFIG_DIR/init.conf"
echo -n "$ROOT_PASSWORD" > "$CONFIG_DIR/passwd"

# Запускаем Lampac
exec /app/lampac -config "$CONFIG_DIR/init.conf"
