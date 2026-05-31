# Сборка
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS builder

WORKDIR /source
RUN git clone https://github.com/lampac-nextgen/lampac.git .
RUN dotnet publish -c Release -o /app --self-contained false

# Финальный образ
FROM mcr.microsoft.com/dotnet/aspnet:9.0

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /lampac
COPY --from=builder /app .
COPY run.sh /run.sh
RUN chmod a+x /run.sh

VOLUME [ "/data" ]
EXPOSE 9118
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

CMD ["/run.sh"]
