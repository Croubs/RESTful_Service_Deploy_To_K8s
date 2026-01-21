# RESTful Service to Deploy to K8s

Small web service to deploy to K8s (Minikube locally).

## Prerequisites
- **Python 3.8+**
- **Docker**
- **kubectl**
- **Minikube** (for local K8s cluster)
- **Git**

## Structure
- `.github/workflows/` → CI pipeline
- `k8s/` → K8s manifests and script for deploy ops
- `project/` → API code
- `tests/` → API tests code

## Technologies
- **FastAPI** → for the API
- **Pytest** → for testing the API
- **Docker** → for containerizing
- **GitHub Actions** → for the CI pipeline
- **Kubernetes (Minikube)** → for orchestration

## How to Run the Service Locally
1. Create a virtual environment
   ```bash
   python -m venv env
   source env/bin/activate  # Linux/Mac
   # or
   env\Scripts\activate     # Windows
   ```
2. Install dependencies
   ```bash
   pip install -r requirements.txt
   ```
3. Run app
   ```bash
   uvicorn main:app --reload
   ```

## Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Returns simple message |
| GET | `/hello` | Returns simple message |
| GET | `/health` | Returns app health status |

## API Documentation
Once the API is running you can access the Swagger UI API docs through:
```
http://localhost:8000/docs
```

## How to Run Tests
### Run all tests
```bash
pytest -v
```
### Run tests with coverage
```bash
pytest --cov=project
```

## Docker
### Build the image
```bash
docker build -t restful-service .
```

### Run the container
```bash
docker run -p 8000:8000 restful-service
```

### Test the container
```bash
curl http://localhost:8000/health
```

## Docker Image
Images are automatically built and pushed to Docker Hub via GitHub Actions:
- Repository:
https://hub.docker.com/repository/docker/croubs/restful_service/
- Tags:
   - `latest` → main branch
   - `sha-XXXXXX` → commit-specific versions 

## Development Workflow
1. Develop and test locally, use the develop branch for commits
2. Push to develop branch
   * Note: this triggers the GitHub Actions workflow which is explained in the next section
3. Create a pull request to main when you need to deploy a new image version for production

## How the CI/CD Workflow Operates
1. Push to develop or main, or create a pull request to main
2. The API is run on a Linux GitHub Actions runner and tested
3. Save the coverage test report into an artifact
4. If the event isn't a pull request, login to Docker Hub
   * You should set the dockerhub username in the variables and the dockerhub token in the secrets
5. Build a new docker image
6. Run and test the image
7. If the event is not a pull request, push the new image to Docker Hub. If the push was to the main branch, add the 'latest' tag to the image

## How to Deploy on Minikube
1. Run minikube
   ```bash
   minikube start
   ```
2. Apply the deployment
   ```bash
   kubectl apply -f k8s/deployment.yml
   ```
3. Access the API using port-forward
   ```bash
   kubectl port-forward deployment/restful-service-deployment 8000:8000
   ```

## Using manage.sh for Deployment Operations
To use this script appropriately, run the following commands in the `k8s/` directory. Minikube should already be running.

### Deploy
```bash
./manage.sh deploy
```

### Update
```bash
./manage.sh update sha-XXXXXX    # Update to specific tag
./manage.sh update           # Update to latest tag
```

### Rollback
```bash
./manage.sh rollback
```

### Scale
```bash
./manage.sh scale 5          # Scale to 5 replicas
./manage.sh scale            # Scale to default (3 replicas)
```

### Port-forward
```bash
./manage.sh port-forward 8080    # Forward to localhost:8080
./manage.sh port-forward         # Forward to localhost:8000
```
