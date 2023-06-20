```
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo apt-get install jenkins
sudo nano /etc/apt/sources.list.d/jenkins.list

deb http://pkg.jenkins.io/debian-stable binary/

sudo apt-get update
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA
sudo apt-get update
sudo apt-get install jenkins
sudo apt-get install -f
sudo systemctl start jenkins
sudo service jenkins status
sudo service jenkins start
sudo service jenkins status
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
