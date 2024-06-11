#!/bin/bash

# Set environment variables
CLUSTER_NAME="Karan-Test"
REGION="us-west-1"
BACKEND_CONTAINER_NAME="backend"
FRONTEND_CONTAINER_NAME="frontend"
FRONTEND_TG_ARN="arn:aws:elasticloadbalancing:us-west-1:058264385073:targetgroup/frontend/f736efd1a9ff0e17"
BACKEND_TG_ARN="arn:aws:elasticloadbalancing:us-west-1:058264385073:targetgroup/backend/82f2886ddc37768a"
BACKEND_PORT="3000"
FRONTEND_PORT="80"

# Pre-build phase
echo "Starting pre-build phase..."
echo "Removing all existing Docker images..."
# Add commands for any cleanup required before building
echo "Pre-build phase completed."

# Build phase
echo "Starting build phase..."
echo "Configuring ECS CLI..."
ecs-cli configure --cluster $CLUSTER_NAME --region $REGION --default-launch-type EC2 --config-name $CLUSTER_NAME
echo "Creating ECS service..."

ecs-cli compose --project-name $CLUSTER_NAME --file docker-compose.yaml --region $REGION --ecs-profile $CLUSTER_NAME --cluster-config $CLUSTER_NAME create
echo "Creating TASK DEFINITION"
sleep 10
aws ecs update-service --cluster $CLUSTER_NAME --service $CLUSTER_NAME --desired-count 1 --task-definition $CLUSTER_NAME --load-balancers "targetGroupArn=$BACKEND_TG_ARN,containerName=$BACKEND_CONTAINER_NAME,containerPort=$BACKEND_PORT" "targetGroupArn=$FRONTEND_TG_ARN,containerName=$FRONTEND_CONTAINER_NAME,containerPort=$FRONTEND_PORT"
echo "Build phase completed."

# Post-build phase
echo "Starting post-build phase..."
echo "Performing cleanup if necessary..."
# Add any necessary cleanup commands here, for example, removing stopped containers or unused volumes
echo "Post-build phase completed."
