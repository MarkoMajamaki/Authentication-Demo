FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5000
EXPOSE 443

ENV ASPNETCORE_URLS=http://*:5000

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["backend/AuthApi/AuthApi/AuthApi.csproj", "AuthApi/"]
COPY ["backend/AuthApi/AuthApi.Application/AuthApi.Application.csproj", "AuthApi.Application/"]
COPY ["backend/AuthApi/AuthApi.Domain/AuthApi.Domain.csproj", "AuthApi.Domain/"]
COPY ["backend/AuthApi/AuthApi.Infrastructure/AuthApi.Infrastructure.csproj", "AuthApi.Infrastructure/"]
RUN dotnet restore "AuthApi/AuthApi.csproj"
COPY "backend/AuthApi/" "AuthApi/"
WORKDIR "/src/AuthApi/AuthApi/"
RUN dotnet build "AuthApi.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "AuthApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AuthApi.dll"]
