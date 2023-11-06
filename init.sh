#!/bin/bash

# Build the backend image
echo "Building backend image..."
docker pull xavgar9/employee-management-backend:latest

# Build the frontend image
echo "Building frontend image..."
pwd
docker pull xavgar9/employee-management-frontend:latest

# Run docker-compose
echo "Starting containers with docker-compose..."
docker-compose up -d