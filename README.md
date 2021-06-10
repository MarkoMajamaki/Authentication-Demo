# Authentication demo

## Used technologies:
Frontend
* Flutter
* Email, Google and Facebook authentication

Backend
* ASP.NET Core Identity
* Kubernetes
* SQL Server
* Clean architecture

## Before deployment

1. Register your app in Google Firebase to get ClientId and ClientSecret (Firebase authentication service is not used)
2. Register your app in Facebook to get AppId and AppSecret
3. Add these values to backend/AuthApi/AuthApi/appsettomgs-Development.json
4. Create self signed certificate
```bash
openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout deployment/certs/tls.key -out deployment/certs/tls.crt -subj "/CN=localhost" -days 365
```
## Build locally

1. Deploy SQL Server with docker compose
```bash
docker-compose -f "deployment/docker-compose.yaml" up -d --build sqlserver
```
2. Run "All" launch configuration with Visual Studio Code

## Deployment to Kind
```bash
# Deploy
sh deployment/deploy-kind.sh deploy

# Destroy
sh deployment/deploy-kind.sh destroy
```

## Deployment with docker compose
```bash
# Deploy
docker-compose -f deployment/docker-compose.yaml up

# Destroy
docker-compose -f deployment/docker-compose.yaml down
```