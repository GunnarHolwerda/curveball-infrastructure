#!/bin/sh

KEY_FILE="~/Programming/curveball/dev-files/CurveballKey.pem"
IP_ADDRESS=$1

# # Save current IFS
if [ -z "$IP_ADDRESS" ]; then 
  SAVEIFS=$IFS
  # Change IFS to new line. 
  IFS=$'\n'
  INSTANCE_IPS=( $(aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(.SecurityGroups[].GroupName | contains("curveball-realtime-sg")) | .PublicIpAddress') )
  # Restore IFS
  IFS=$SAVEIFS
else
  INSTANCE_IPS=("$IP_ADDRESS")
fi

for ip in "${INSTANCE_IPS[@]}"; do
  ssh -i $KEY_FILE ec2-user@$ip 'bash -s' < ./realtime-setup.sh
  ssh -i $KEY_FILE ec2-user@$ip "sudo aws s3 cp s3://curveball-dev-files/Config/curveball-realtime.service /lib/systemd/system/curveball-realtime.service"
  ssh -i $KEY_FILE ec2-user@$ip "sudo systemctl daemon-reload"
  ssh -i $KEY_FILE ec2-user@$ip "sudo systemctl enable curveball-realtime"
  ssh -i $KEY_FILE ec2-user@$ip "sudo systemctl restart curveball-realtime"
done