deploy()
{
    # Create Kind cluster
    kind create cluster --name authentication-demo 

    # Build images
    docker build -t authentication_demo/auth-api:v1 -f backend/AuthApi/Dockerfile . 
    docker build -t authentication_demo/frontend:v1 -f frontend/Dockerfile frontend/

    # Load images into cluster
    kind load docker-image authentication_demo/auth-api:v1 --name authentication-demo
    kind load docker-image authentication_demo/frontend:v1 --name authentication-demo
    kind load docker-image mcr.microsoft.com/mssql/server:latest --name authentication-demo

    # Deploy Kubernetes services
    kubectl apply -f deployment/kubernetes/namespace.yaml
    kubectl apply -f deployment/kubernetes/sqlserver.yaml
    kubectl apply -f deployment/kubernetes/auth-api.yaml
    kubectl apply -f deployment/kubernetes/frontend.yaml
   
    # Open port 8080 to access frontend
    kubectl port-forward service/frontend -n authentication-demo 5000:80

    # Open port 1433 to access database
    kubectl port-forward service/sqlserver -n authentication-demo 1433:1433
}

destroy()
{
    kind delete cluster --name authentication-demo
}

"$@"