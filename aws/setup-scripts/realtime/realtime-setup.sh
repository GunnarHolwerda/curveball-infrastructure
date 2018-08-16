#!/bin/sh
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
yum -y install nodejs

mkdir ~/realtime
mkdir /etc/init.d/curveball-realtime
cd ~/realtime
curl -H "Authorization: token f914916b1886cd4793ae2465a2b08ebd99714b89" -L https://api.github.com/repos/GunnarHolwerda/QuizRealtime/tarball | tar -xz --strip=1
npm install