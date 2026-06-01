FROM alpine:latest

RUN apk add --no-cache curl jq dotnet9-runtime

WORKDIR /app
RUN curl -L https://github.com/lampac-nextgen/lampac/archive/refs/heads/master.tar.gz | tar xz --strip-components=1

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
