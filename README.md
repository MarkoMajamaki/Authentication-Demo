# Authentication demo

**Repo is still under heavy development and some features might not working!**

## Used technologies:
Frontend
* Flutter

Backend
* ASP.NET
* Kubernetes
* SQL Server

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
docker-compose -f deployment/docker-compose.yml up

# Destroy
docker-compose -f deployment/docker-compose.yml down
```

## Test
```bash
http://localhost:8080
```