#!/bin/sh

KEY_FILE="~/Programming/curveball/dev-files/CurveballKey.pem"
INSTANCE_IP="34.215.65.54"

ssh -i $KEY_FILE ec2-user@$INSTANCE_IP 'bash -s' < ./realtime-setup.sh
scp -i $KEY_FILE -r ./realtime-initd-script.sh ec2-user@$INSTANCE_IP:/etc/init.d/curveball-realtime/
ssh -i $KEY_FILE ec2-user@$INSTANCE_IP "chmod 0770 /etc/init.d/curveball-realtime/realtime-initd-script.sh"
scp -i $KEY_FILE -r "~/Programming/curveball/dev-files/realtime/.env" ec2-user@$INSTANCE_IP:/home/ec2-user/realtime/
ssh -i $KEY_FILE ec2-user@$INSTANCE_IP "update-rc.d curveball-realtime defaults"
ssh -i $KEY_FILE ec2-user@$INSTANCE_IP "service curveball-realtime start"
