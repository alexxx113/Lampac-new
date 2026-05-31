FROM alpine:latest AS builder

RUN apk add --no-cache git go build-base

WORKDIR /build
RUN git clone https://github.com/lampac-nextgen/lampac.git . && \
    go mod download && \
    CGO_ENABLED=0 GOOS=linux go build -o lampac .

FROM alpine:latest
RUN apk add --no-cache ca-certificates jq bash
WORKDIR /app
COPY --from=builder /build/lampac /app/lampac
COPY --from=builder /build/config /app/config.default
COPY run.sh /run.sh
RUN chmod a+x /run.sh
VOLUME ["/data"]
EXPOSE 8080
CMD ["/run.sh"]
