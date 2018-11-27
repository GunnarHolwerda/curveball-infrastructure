#!/bin/sh

PREFIX=$1

### Realtime EC2
# Create realtime security group
aws ec2 create-security-group --group-name curveball-realtime-sg --description "Curveball Realtime SG"
# Create realtime instance
aws ec2 run-instances --image-id ami-a9d09ed1 --count 1 --instance-type t3.nano --key-name CurveballKey --security-groups curveball-realtime-sg
# Authorize access to realtime instances with my IP
aws ec2 authorize-security-group-ingress --group-name curveball-realtime-sg --protocol tcp --port 22 --cidr 73.96.78.57/32

### RDS
# Create RDS Security group
aws ec2 create-security-group --group-name curveball-db-sg --description "Security group for the curveball database"
aws ec2 authorize-security-group-ingress --group-name curveball-db-sg --protocol tcp --port 5432 --cidr 73.96.78.57/32
# Create RDS Instance
aws rds create-db-instance --db-security-groups curveball-db-sg --engine postgres --master-username root --master-user-password "ty?D9XtkcQ3*},md[=2i" --engine-version "10.4" --db-instance-identifier curveball-db --db-instance-class db.t2.micro --allocated-storage 5

### Elasticache
# Create Cache Security group
aws ec2 create-security-group --group-name curveball-cache-sg --description "Security group for access to redis cache"
# Create Cluster
aws elasticache create-cache-cluster --cache-cluster-id curveball-cluster --cache-node-type cache.t2.micro --engine redis --engine-version 4.0 --num-cache-nodes 1

### Lambda Quiz Endpoints
# Create quiz endpoints security group
aws ec2 create-security-group --group-name curveball-quiz-sg --description "Security group for AWS lambda quiz functions"
aws ec2 authorize-security-group-ingress --group-name curveball-quiz-sg --protocol tcp --port 443 --cidr 73.96.78.57/32

### Curveball Controller
# Create S3 bucket for controller
aws s3api create-bucket --bucket $(PREFIX)-curveball-controller --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
aws s3api put-bucket-policy --bucket $(PREFIX)-curveball-controller --policy file://~/Programming/curveball/infrastructure/aws/policies/controller-bucket-policy.json
# Enable bucket for static website hosting
aws s3 website s3://$(PREFIX)-curveball-controller/ --index-document index.html --error-document index.html

# Security Group Rules
aws ec2 authorize-security-group-ingress --group-name curveball-cache-sg --source-group curveball-realtime-sg --protocol tcp --port 6379
aws ec2 authorize-security-group-ingress --group-name curveball-cache-sg --source-group curveball-quiz-sg --protocol tcp --port 6379
aws ec2 authorize-security-group-ingress --group-name curveball-db-sg --source-group curveball-quiz-sg --protocol tcp --port 5432
aws ec2 authorize-security-group-ingress --group-name curveball-realtime-sg --source-group curveball-realtime-lb-sg --protocol tcp --port 3001

# Load balancer
aws ec2 create-security-group --group-name curveball-realtime-lb-sg --description "Security group for realtime load balancer"
aws ec2 authorize-security-group-ingress --group-name curveball-realtime-lb-sg --protocol tcp --port 443 --cidr 73.96.78.57/32
aws elbv2 create-target-group --name curveball-$(PREFIX)-realtime-instances --target-type ip --protocol HTTPS --port 443 --vpc-id vpc-bc5429d4 --health-check-protocol HTTPS --health-check-path /health-check --health-check-port 3001
# This requires the arn from the target group created above, requires private ip address of realtime ec2 instances
aws elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-west-2:344946851001:targetgroup/curveball-$(PREFIX)-realtime-instances/a5ceb867a5c389c7 --targets Id=172.31.38.103,Port=3001
aws elbv2 create-load-balancer --name curveball-$(PREFIX)-realtime-lb --subnets subnet-bf5429d7 subnet-be5429d6 --security-groups sg-0061b6f0b4cdc18fb
# This requires the arn from the target group created above
aws elbv2 create-listener  \
--load-balancer-arn arn:aws:elasticloadbalancing:us-west-2:344946851001:loadbalancer/app/curveball-$(PREFIX)-realtime-lb/a633b6eedd0e6ded \
--protocol HTTPS \
--port 443 \
--certificates CertificateArn=	arn:aws:acm:us-west-2:344946851001:certificate/d1753012-04f4-4ac7-a3f6-6e324d576232 \
--default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-west-2:344946851001:targetgroup/curveball-$(PREFIX)-realtime-instances/a5ceb867a5c389c7

# TODO: Create listener to return 503 if no healthy instances 

./dns.sh
# Create iam instance profile to attach to realtime instances
aws iam create-instance-profile --instance-profile-name RealtimeInstance-Instance-Profile
aws iam add-role-to-instance-profile --role-name RealtimeInstance --instance-profile-name RealtimeInstance-Instance-Profile