#!/bin/sh

KEY_FILE="~/Programming/curveball/dev-files/CurveballKey.pem"
# Save current IFS
SAVEIFS=$IFS
# Change IFS to new line. 
IFS=$'\n'
INSTANCE_IPS=( $(aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(.SecurityGroups[].GroupName | contains("curveball-realtime-sg")) | .PublicIpAddress') )
# Restore IFS
IFS=$SAVEIFS

for ip in "${INSTANCE_IPS[@]}"; do
  ssh -i $KEY_FILE ec2-user@$ip 'bash -s' < ./realtime-setup.sh
  scp -i $KEY_FILE -r ./curveball-realtime.service ec2-user@$ip:/home/ec2-user
  ssh -i $KEY_FILE ec2-user@$ip "sudo cp ~/curveball-realtime.service /lib/systemd/system/curveball-realtime.service"
  ssh -i $KEY_FILE ec2-user@$ip "sudo systemctl daemon-reload"
  ssh -i $KEY_FILE ec2-user@$ip "sudo systemctl enable curveball-realtime"
  ssh -i $KEY_FILE ec2-user@$ip "sudo systemctl restart curveball-realtime"
done