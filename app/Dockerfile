# ---- Этап сборки ----
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Клонируем ваш репозиторий
RUN git clone https://github.com/lampac-nextgen/lampac.git .

# Публикуем (собираем) проект
RUN dotnet publish "Lampac.sln" -c Release -o /app/publish

# ---- Финальный образ ----
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Копируем результат сборки
COPY --from=build /app/publish .

# Копируем скрипт запуска
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Порты, которые использует приложение
EXPOSE 9118
EXPOSE 3000

# Переменные окружения для ASP.NET Core
ENV ASPNETCORE_URLS=http://+:9118
ENV DOTNET_USE_POLLING_FILE_WATCHER=1

# Точка входа
ENTRYPOINT ["/run.sh"]
