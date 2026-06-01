#!/usr/bin/env bashio

CONFIG_DIR="/data/config"
INIT_CONF="$CONFIG_DIR/init.conf"
PASSWD_FILE="$CONFIG_DIR/passwd"

# Создаем каталог для конфигурации, если он не существует
mkdir -p "$CONFIG_DIR"

# Копируем пример конфигурации, если пользовательского файла еще нет
if [ ! -f "$INIT_CONF" ]; then
    cp /app/config/example.init.conf "$INIT_CONF"
    bashio::log.info "Пример конфигурации скопирован в $INIT_CONF. Пожалуйста, отредактируйте его при необходимости."
fi

# Проверяем и устанавливаем пароль из UI
ROOT_PASSWORD=$(bashio::config 'root_password')
if ! grep -q "^password:" "$INIT_CONF"; then
    echo "password: $ROOT_PASSWORD" >> "$INIT_CONF"
else
    sed -i "s/^password:.*/password: $ROOT_PASSWORD/" "$INIT_CONF"
fi

# Сохраняем пароль в отдельный файл
echo -n "$ROOT_PASSWORD" > "$PASSWD_FILE"

# Запускаем приложение
bashio::log.info "Запуск Lampac..."
exec dotnet /app/Lampac.dll
