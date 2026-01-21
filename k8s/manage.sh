#!/bin/bash

APP_NAME="restful-service"
NAMESPACE="default"
IMAGE_BASE="croubs/restuful-service"

deploy() {
    echo "Deploying $APP_NAME..."
    kubectl apply -f deployment.yml
    kubectl rollout status deployment/$APP_NAME
    echo "Deployment complete!"
}

update() {
    TAG=${1:-latest}
    IMAGE="$IMAGE_BASE:$TAG"
    echo "Updating $APP_NAME with image: $IMAGE"
    kubectl set image deployment/$APP_NAME $APP_NAME=$IMAGE
    kubectl rollout status deployment/$APP_NAME
    echo "Update complete!"
}

rollback() {
    echo "Rolling back $APP_NAME..."
    kubectl rollout undo deployment/$APP_NAME
    kubectl rollout status deployment/$APP_NAME
    echo "Rollback complete!"
}

scale() {
    REPLICAS=${1:-3}
    echo "Scaling $APP_NAME to $REPLICAS replicas..."
    kubectl scale deployment/$APP_NAME --replicas=$REPLICAS
    kubectl rollout status deployment/$APP_NAME
    echo "Scaling complete!"
}

port_forward() {
    PORT=${1:-8000}
    echo "Port forwarding $APP_NAME to localhost:$PORT..."
    kubectl port-forward deployment/$APP_NAME $PORT:8000
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