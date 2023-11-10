#!/bin/bash

# Build the backend image
echo "Building backend image..."
docker build -t backend ./Backend

# Build the frontend image
echo "Building frontend image..."
pwd

# docker pull xavgar9/employee-management-frontend:latest
docker build -t frontend ./Frontend

# Run docker-compose
echo "Starting containers with docker-compose..."
docker compose up
