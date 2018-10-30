#!/bin/sh
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

mkdir ~/realtime
sudo touch /var/log/curveball-realtime.log
sudo chown ec2-user /var/log/curveball-realtime.log
chmod 0644 /var/log/curveball-realtime.log
cd ~/realtime
mkdir etc
openssl req -newkey rsa:2048 -new -nodes -keyout etc/key.pem -out etc/csr.pem -subj "/C=US/ST=Oregon/L=Portland/O=Dis/CN=$(hostname)"
openssl x509 -req -days 365 -in etc/csr.pem -signkey etc/key.pem -out etc/server.crt -days 15000
curl -H "Authorization: token f914916b1886cd4793ae2465a2b08ebd99714b89" -L https://api.github.com/repos/GunnarHolwerda/QuizRealtime/tarball/master | tar -xz --strip=1
npm install

# To follow logs of realtime service: sudo journalctl -u curveball-realtime -f