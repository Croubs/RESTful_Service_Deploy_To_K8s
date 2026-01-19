import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
from fastapi.testclient import TestClient
from project import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome"}

def test_read_hello():
    response = client.get("/hello")
    assert response.status_code == 200
    assert response.json() == {"Hello": "World"}

def test_read_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"detail": "OK"}

def test_invalid_endpoint():
    response = client.get("/invalid")
    assert response.status_code == 404