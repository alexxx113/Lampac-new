#!/bin/sh

CONFIG_DIR=/data/config
mkdir -p $CONFIG_DIR

if [ ! -f $CONFIG_DIR/init.conf ]; then
    cp /app/config/example.init.conf $CONFIG_DIR/init.conf
fi

ROOT_PASSWORD=$(jq -r '.root_password' /data/options.json 2>/dev/null || echo "changeme")
sed -i "s/^password:.*/password: $ROOT_PASSWORD/" $CONFIG_DIR/init.conf

exec dotnet /app/Lampac.dll --config=$CONFIG_DIR/init.conf
