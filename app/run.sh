#!/usr/bin/env bashio

set -e

# Конфигурация
LAMPAC_DIR="/lampac"
DATA_CONFIG_DIR="/data/config"

bashio::log.info "Preparing Lampac environment..."

# Создаём папку для конфигов в томе /data
mkdir -p "${DATA_CONFIG_DIR}"

# Если в томе /data нет init.conf, копируем дефолтный из образа
if [ ! -f "${DATA_CONFIG_DIR}/init.conf" ]; then
    bashio::log.info "No user config found, copying default init.conf"
    cp "${LAMPAC_DIR}/config/example.init.conf" "${DATA_CONFIG_DIR}/init.conf"
fi

# Если в томе /data нет passwd, создаём пустой (будет перезаписан паролем)
if [ ! -f "${DATA_CONFIG_DIR}/passwd" ]; then
    touch "${DATA_CONFIG_DIR}/passwd"
fi

# Копируем конфиги из /data/config в /lampac (как при монтировании тома в оригинальном docker-compose)
cp "${DATA_CONFIG_DIR}/init.conf" "${LAMPAC_DIR}/init.conf"
cp "${DATA_CONFIG_DIR}/passwd" "${LAMPAC_DIR}/passwd"

# Устанавливаем пароль из опции аддона
ROOT_PASSWORD=$(bashio::config 'root_password')
bashio::log.info "Setting root password in init.conf and passwd"

# Обновляем пароль в init.conf (ищем строку password:)
if grep -q "^password:" "${LAMPAC_DIR}/init.conf"; then
    sed -i "s/^password:.*/password: ${ROOT_PASSWORD}/" "${LAMPAC_DIR}/init.conf"
else
    echo "password: ${ROOT_PASSWORD}" >> "${LAMPAC_DIR}/init.conf"
fi

# Записываем пароль в passwd (как в инструкции printf)
echo -n "${ROOT_PASSWORD}" > "${LAMPAC_DIR}/passwd"

# Возвращаем обратно в /data/config, чтобы изменения сохранились
cp "${LAMPAC_DIR}/init.conf" "${DATA_CONFIG_DIR}/init.conf"
cp "${LAMPAC_DIR}/passwd" "${DATA_CONFIG_DIR}/passwd"

bashio::log.info "Starting Lampac daemon..."

# Запуск – в зависимости от содержимого образа:
# Если использовался готовый образ lampac-nextgen/lampac, то исполняемый файл может называться lampac или Lampac.dll
# Проверяем наличие
if [ -f "${LAMPAC_DIR}/lampac" ]; then
    exec "${LAMPAC_DIR}/lampac" -config "${LAMPAC_DIR}/init.conf"
elif [ -f "${LAMPAC_DIR}/Lampac.dll" ]; then
    exec dotnet "${LAMPAC_DIR}/Lampac.dll" --config="${LAMPAC_DIR}/init.conf"
else
    bashio::log.error "No executable found in /lampac"
    exit 1
fi
