curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

mkdir ~/realtime
cd ~/realtime
curl -H "Authorization: token f914916b1886cd4793ae2465a2b08ebd99714b89" -L https://api.github.com/repos/GunnarHolwerda/QuizRealtime/tarball | tar -xz --strip=1
npm install
npm start
