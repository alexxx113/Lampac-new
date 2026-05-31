FROM alpine:latest

RUN apk add --no-cache ca-certificates jq bash curl

WORKDIR /app

# Скачиваем бинарник под вашу архитектуру
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64)  FILE="lampac-linux-amd64" ;; \
        aarch64) FILE="lampac-linux-arm64" ;; \
        armv7l)  FILE="lampac-linux-armv7" ;; \
        *)       echo "Unsupported arch: $ARCH"; exit 1 ;; \
    esac && \
    curl -L "https://github.com/lampac-nextgen/lampac/releases/latest/download/${FILE}" -o lampac && \
    chmod +x lampac

# Скачиваем пример конфига
RUN mkdir -p config.default && \
    curl -L https://raw.githubusercontent.com/lampac-nextgen/lampac/master/config/init.conf -o config.default/init.conf

COPY run.sh /run.sh
RUN chmod a+x /run.sh

VOLUME ["/data"]

EXPOSE 8080

CMD ["/run.sh"]
