#!/bin/bash

DEPLOYMENT_NAME="restful-service-deployment"
CONTAINER_NAME="restful-service"
NAMESPACE="default"
IMAGE_BASE="croubs/restful-service"

deploy() {
    echo "Deploying $DEPLOYMENT_NAME..."
    kubectl apply -f deployment.yml
    kubectl rollout status deployment/$DEPLOYMENT_NAME
    echo "Deployment complete!"
}

update() {
    TAG=${1:-latest}
    IMAGE="$IMAGE_BASE:$TAG"
    echo "Updating $DEPLOYMENT_NAME with image: $IMAGE"
    kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$IMAGE
    kubectl rollout status deployment/$DEPLOYMENT_NAME
    echo "Update complete!"
}

rollback() {
    echo "Rolling back $DEPLOYMENT_NAME..."
    kubectl rollout undo deployment/$DEPLOYMENT_NAME
    kubectl rollout status deployment/$DEPLOYMENT_NAME
    echo "Rollback complete!"
}

scale() {
    REPLICAS=${1:-3}
    echo "Scaling $DEPLOYMENT_NAME to $REPLICAS replicas..."
    kubectl scale deployment/$DEPLOYMENT_NAME --replicas=$REPLICAS
    kubectl rollout status deployment/$DEPLOYMENT_NAME
    echo "Scaling complete!"
}

port_forward() {
    PORT=${1:-8000}
    echo "Port forwarding $DEPLOYMENT_NAME to localhost:$PORT..."
    kubectl port-forward deployment/$DEPLOYMENT_NAME $PORT:8000
}

case "$1" in
    deploy)
        deploy
        ;;
    update)
        update $2
        ;;
    rollback)
        rollback
        ;;
    scale)
        scale $2
        ;;
    port-forward)
        port_forward $2
        ;;
    *)
        echo "Usage: $0 {deploy|update [tag]|rollback|scale [replicas]|port-forward [port]}"
        exit 1
        ;;
esac