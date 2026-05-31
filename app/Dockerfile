FROM alpine:latest AS builder

RUN apk add --no-cache git go build-base gcc musl-dev

WORKDIR /build

# Клонируем репозиторий с явным указанием ветки main/master
RUN git clone --depth 1 https://github.com/lampac-nextgen/lampac.git . || \
    git clone --depth 1 https://github.com/lampac-nextgen/lampac.git .

# Выводим список файлов для отладки
RUN ls -la

# Собираем с включёнными модулями и статической линковкой
RUN go mod download && \
    CGO_ENABLED=1 GOOS=linux go build -a -ldflags '-linkmode external -extldflags "-static"' -o lampac .

# Проверяем, что бинарник создался
RUN test -f lampac || (echo "Build failed" && exit 1)

FROM alpine:latest

RUN apk add --no-cache ca-certificates jq bash

WORKDIR /app

COPY --from=builder /build/lampac /app/lampac
COPY --from=builder /build/config /app/config.default

RUN chmod +x /app/lampac

COPY run.sh /run.sh
RUN chmod a+x /run.sh

VOLUME ["/data"]

EXPOSE 8080

CMD ["/run.sh"]
