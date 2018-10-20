#!/bin/sh

HOSTED_ZONE_ID=$(aws route53 list-hosted-zones | jq -r '.HostedZones[] | select(.Name | contains("curveball.tv")) | .Id')

# Create realtime
REALTIME_LOAD_BALANCER_PUBLIC_DNS=$(aws elbv2 describe-load-balancers | jq '.LoadBalancers[] | select(.LoadBalancerName | contains("curveball-dev-realtime")) | .DNSName')

# Create Quiz API
QUIZ_API_DNS=$(aws apigateway get-domain-name --domain-name "quiz.dev.curveball.tv" | jq '.regionalDomainName')

# Create DB
RDS_DB_DNS=$(aws rds describe-db-instances | jq '.DBInstances[] | select(.DBInstanceIdentifier | contains("curveball-dev-db")) | .Endpoint.Address')

# Create Cache

# Create Controller
CONTROLLER_DNS=$(aws cloudfront list-distributions | jq '.DistributionList.Items[] | select(.DefaultCacheBehavior.TargetOriginId | contains("S3-dev-curveball-controller")) | .DomainName')

# Create Live
STREAM_SERVER_DNS=$(aws ec2 describe-instances | jq '.Reservations[].Instances[] | select(.SecurityGroups[].GroupName | contains("test-stream-server")) | .PublicDnsName')

echo HOSTED_ZONE_ID: $HOSTED_ZONE_ID
echo REALTIME_LB_DNS: $REALTIME_LOAD_BALANCER_PUBLIC_DNS
echo QUIZ_API_DNS: $QUIZ_API_DNS
echo RDS_DB_DNS: $RDS_DB_DNS
echo CONTROLLER_DNS: $CONTROLLER_DNS
echo STREAM_SERVER_DNS: $STREAM_SERVER_DNS

# Create records
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '{
  "Comment": "Create dev DNS",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "realtime.dev.curveball.tv",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{
          "Value": '"$REALTIME_LOAD_BALANCER_PUBLIC_DNS"'
        }]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "quiz.dev.curveball.tv",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{
          "Value": '"$QUIZ_API_DNS"'
        }]
      }
    },{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "db.dev.curveball.tv",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{
          "Value": '"$RDS_DB_DNS"'
        }]
      }
    },{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "controller.dev.curveball.tv",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{
          "Value": '"$CONTROLLER_DNS"'
        }]
      }
    },{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "live.dev.curveball.tv",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{
          "Value": '"$STREAM_SERVER_DNS"'
        }]
      }
    }
  ]
}'