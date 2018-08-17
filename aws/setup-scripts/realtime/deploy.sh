#!/bin/sh

KEY_FILE="~/Programming/curveball/dev-files/CurveballKey.pem"
INSTANCE_IP="52.40.33.78"

ssh -i $KEY_FILE ec2-user@$INSTANCE_IP 'bash -s' < ./realtime-setup.sh
scp -i $KEY_FILE -r ./curveball-realtime.service ec2-user@$INSTANCE_IP:/home/ec2-user
ssh -i $KEY_FILE ec2-user@$INSTANCE_IP "sudo cp ~/curveball-realtime.service /lib/systemd/system/curveball-realtime.service"
ssh -i $KEY_FILE ec2-user@$INSTANCE_IP "sudo systemctl daemon-reload"
ssh -i $KEY_FILE ec2-user@$INSTANCE_IP "sudo systemctl enable curveball-realtime"
ssh -i $KEY_FILE ec2-user@$INSTANCE_IP "sudo systemctl start curveball-realtime"
