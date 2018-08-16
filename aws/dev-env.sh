#!/bin/sh
### Realtime EC2
# Create realtime security group
aws ec2 create-security-group --group-name curveball-realtime-sg --description "Curveball Realtime SG"
# Create realtime instance
aws ec2 run-instances --image-id ami-a9d09ed1 --count 1 --instance-type t2.micro --key-name CurveballKey --security-groups curveball-realtime-sg
# Authorize access to realtime instances with my IP
aws ec2 authorize-security-group-ingress --group-name curveball-realtime-sg --protocol tcp --port 22 --cidr 73.96.78.57/32

### RDS
# Create RDS Security group
aws ec2 create-security-group --group-name curveball-db-sg --description "Security group for the curveball database"
aws ec2 authorize-security-group-ingress --group-name curveball-db-sg --protocol tcp --port 5432 --cidr 73.96.78.57/32
# Create RDS Instance
aws rds create-db-instance --db-security-groups curveball-db-sg --engine postgres --master-username developer --master-user-password "ty?D9XtkcQ3*},md[=2i" --engine-version "10.4" --db-instance-identifier curveball-db --db-instance-class db.t2.micro --allocated-storage 5

### Elasticache
# Create Cache Security group
aws ec2 create-security-group --group-name curveball-cache-sg --description "Security group for access to redis cache"
# Create Cluster
aws elasticache create-cache-cluster --cache-cluster-id curveball-cluster --cache-node-type cache.t2.micro --engine redis --engine-version 4.0 --num-cache-nodes 1 --cache-security-group-names curveball-cache-sg

### Lambda Quiz Endpoints
# Create quiz endpoints security group
aws ec2 create-security-group --group-name curveball-quiz-sg --description "Security group for AWS lambda quiz functions"

### Curveball Controller
# Create S3 bucket for controller
aws s3api create-bucket --bucket dev-curveball-controller --region us-west-2
# Enable bucket for static website hosting
aws s3 website s3://dev-curveball-controller/ --index-document index.html --error-document index.html

# Security Group Rules
aws ec2 authorize-security-group-ingress --group-name curveball-cache-sg --source-group curveball-realtime-sg --protocol tcp --port 6379
aws ec2 authorize-security-group-ingress --group-name curveball-cache-sg --source-group curveball-quiz-sg --protocol tcp --port 6379
aws ec2 authorize security-group-ingress --group-name curveball-db-sg --source-group curveball-quiz-sg --protocol tcp --port 5432