FROM ghcr.io/lampac-nextgen/lampac:latest

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENV ASPNETCORE_URLS=http://+:9118
ENTRYPOINT ["/run.sh"]
