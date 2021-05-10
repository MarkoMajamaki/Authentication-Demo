deploy()
{
    # Create self signed sertificate
	openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout certs/tls.key -out certs/tls.crt -subj "/CN=localhost" -days 365

    # Build images
    docker build -t authentication_demo/auth-api:v1 -f backend/AuthApi/Dockerfile . 
    docker build -t authentication_demo/frontend:v1 -f frontend/Dockerfile .

    # Create Kind cluster
    kind create cluster --name authentication-demo 

    # Load images into cluster
    kind load docker-image authentication_demo/auth-api:v1 --name authentication-demo
    kind load docker-image authentication_demo/frontend:v1 --name authentication-demo
    kind load docker-image mcr.microsoft.com/mssql/server:latest --name authentication-demo

    # Deploy Kubernetes services
    kubectl apply -f kubernetes/auth-api.yaml
    kubectl apply -f kubernetes/frontend.yaml
    kubectl apply -f kubernetes/sqlserver.yaml
   
    # Open port 8080 to access frontend
    kubectl port-forward service/frontend -n authentication-demo 8080:80
}

destroy()
{
    kind delete cluster --name authentication-demo
}

"$@"