ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM $BUILD_FROM

# Устанавливаем .NET Runtime (Lampac нужен)
RUN apk add --no-cache dotnet9-runtime icu-libs krb5-libs libgcc libintl libstdc++ zlib

# Скачиваем готовый бинарник Lampac (последний релиз)
WORKDIR /app
RUN arch="$(uname -m)" && \
    case "$arch" in \
        x86_64)  url="https://github.com/lampac-nextgen/lampac/releases/latest/download/lampac-linux-x64" ;; \
        aarch64) url="https://github.com/lampac-nextgen/lampac/releases/latest/download/lampac-linux-arm64" ;; \
        *)       echo "Unsupported arch: $arch"; exit 1 ;; \
    esac && \
    wget -O lampac "$url" && \
    chmod +x lampac

# Копируем пример конфига
RUN mkdir -p /app/config
RUN wget -O /app/config/init.conf https://raw.githubusercontent.com/lampac-nextgen/lampac/master/config/example.init.conf

# Скрипт запуска (без bashio – обычный sh)
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
