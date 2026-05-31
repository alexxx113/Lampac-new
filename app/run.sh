#!/usr/bin/env bashio

set -e

ROOT_PASSWORD=$(bashio::config 'root_password')
WEB_PORT=$(bashio::config 'web_port')

mkdir -p /data/config /data/plugins

if [ ! -f /data/config/init.conf ]; then
    cp /app/config.default/init.conf /data/config/init.conf
fi

sed -i "s/^password:.*/password: ${ROOT_PASSWORD}/" /data/config/init.conf
sed -i "s/^port:.*/port: ${WEB_PORT}/" /data/config/init.conf

echo -n "$ROOT_PASSWORD" > /data/config/passwd

exec /app/lampac -config /data/config/init.conf -plugins /data/plugins
