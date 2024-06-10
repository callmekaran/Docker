**Deploying Application on AWS ECS**

**Step 1: Setup AWS CLI**

#Open a terminal and set up AWS CLI environment variables:

export AWS_ACCESS_KEY_ID="AKIAQ3YYKVDXMWO"
export AWS_SECRET_ACCESS_KEY="tgl1GW5Uziq1RUU6MaqWu8FEqwgBL2un"
export AWS_DEFAULT_REGION=ap-south-1


**Step 2: Setup CLuster First**

#!/bin/bash
set -e

# Define variables
PROFILE_NAME=tutorial
CLUSTER_NAME=tutorial-cluster
REGION=us-west-2
LAUNCH_TYPE=EC2

# Configure ECS profile
ecs-cli configure profile --profile-name "$PROFILE_NAME" --access-key "$AWS_ACCESS_KEY_ID" --secret-key "$AWS_SECRET_ACCESS_KEY"
ecs-cli configure --cluster "$CLUSTER_NAME" --default-launch-type "$LAUNCH_TYPE" --region "$REGION" --config-name "$PROFILE_NAME"

**Step 3: Create Key Pair (if not exits)**

aws ec2 create-key-pair --key-name tutorial-cluster --query 'KeyMaterial' --output text --region us-west-1 > tutorial-cluster.pem

**Step 4: Configure ECS Cluster**

#!/bin/bash

# Define variables
KEY_PAIR=tutorial-cluster

# Set up ECS cluster
ecs-cli up \
  --keypair $KEY_PAIR  \
  --capability-iam \
  --size 2 \
  --instance-type t3.medium \
  --tags project=tutorial-cluster,owner=raphael \
  --cluster-config tutorial \
  --ecs-profile tutorial --force


**Step 5: Deploy Docker Compose Services**

ecs-cli configure --cluster tutorial --region us-west-2 --default-launch-type EC2 --config-name tutorial

ecs-cli compose --project-name tutorial --file docker-compose.yaml --debug service up --deployment-max-percent 100 --deployment-min-healthy-percent 0 --region us-west-2 --ecs-profile tutorial --cluster-config tutorial

**step 6 : Manual Step Create Target Groups add ec2, load balancer**

**step 7 : Update Service with This command to attach elb**

aws ecs update-service \
    --cluster tutorial-cluster \
    --service tutorial \
    --desired-count 2 \
    --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:us-west-2:058264385073:targetgroup/Frontend/08bbc33ec6e388f5,containerName=frontend,containerPort=80 targetGroupArn=arn:aws:elasticloadbalancing:us-west-2:058264385073:targetgroup/Backend/4dfefc78c1e7b1a0,containerName=backend,containerPort=3000 \
    --region us-west-2



###############################################**NOTE**#############################################

**You can do things manually too**

Just use step5 and step 7 





