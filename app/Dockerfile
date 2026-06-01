FROM ghcr.io/lampac-nextgen/lampac:latest

# Копируем скрипт и сразу устанавливаем права на выполнение
COPY --chmod=755 run.sh /run.sh

ENV ASPNETCORE_URLS=http://+:9118
ENTRYPOINT ["/run.sh"]
