# Continuous Integration using Jenkins

## Installing tools
First we need to install `Jenkins` and `Maven`
```
#!/bin/bash

# Update packages
sudo apt update

# Install Java
sudo apt install -y openjdk-11-jdk

# Install Jenkins dependencies
sudo apt install -y git
sudo apt install -y maven  ##THIS ONE NOT ABLE TO RUN PLEASE CHECK ONCE

# Install Jenkins
# sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# sudo echo "deb https://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list.d/jenkins.list
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
  
sudo apt update
sudo apt install -y jenkins
```
start `jenkins`
```
sudo systemctl start jenkins
```

## Installing Tomcat Server
For installing tomcat navigate to `/opt` directory, then run the following commands
```
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.76/bin/apache-tomcat-9.0.76.tar.gz
sudo tar -xvzf apache-tomcat-9.0.76.tar.gz
sudo mv apache-tomcat-9.0.76 tomcat      // rename the dirctory to tomcat
```

## Tomcat configuration
We need to edit context.xml to access manager gui. Comment the following codes in the following files
```
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
-->


nano /opt/tomcat/webapps/host-manager/META-INF/context.xml
nano /opt/tomcat/webapps/manager/META-INF/context.xml

```

## Change the default port no for Tomcat
Jenkins is running in port no `8080` and tomcat by default is run in port no `8080`. we need to change the port no to `8082` to run it without errors.
```
sudo nano /opt/tomcat/conf/server.xml

<Connector port="8082" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           maxParameterCount="1000"
               />
```

## Add Username and Password for Tomcat
navigate to `/opt/tomcat/conf/` and using `nano` editor open `tomcat-users.xml` and add the following codes before `</tomcat-users>`
```
<role rolename="manager-gui"/>
<role rolename="admin-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="admin" password="admin" roles="manager-gui,admin-gui,manager-script"/>
```
after configure tomcat server restart it to apply the changes
```
cd /opt/tomcat/bin
./shutdown.sh
./startup.sh
```

## Clone the Medicure repository
1. Clone the Medicure repository form the `mc01` branch.
2. Create new github repository in your account. 
3. Clone the created repository and copy the Medicaure files to your cloned directory.
4. For running the project in external tomcat we need to add `ServletInitializer.java` and give `dependency`
5. create `ServletInitializer.java` in `/src/main/java/com/nubeera/` and copy the following codes
```
package com.nubeera;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

public class ServletInitializer extends SpringBootServletInitializer {
  
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(MedicureApplication.class);
    }
}
```
6. Add the following `dependency` to run the project in external tomcat 
```
      <dependency>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-starter-tomcat</artifactId>
         <scope>provided</scope>
      </dependency>
```

## Jenkins configuration
1. Jenkins by default run in port no `8080`, to access jenkins GUI open the following link in browser `http://localhost:8080`.
2. To login we need to copy the Administrator password, to get the Administrator password use the following command.
```
cat /var/lib/jenkins/secrets/initialAdminPassword
```
3. Copy the password and paste it in jenkins Administrator password field.
4. Click the `X` on the right top to close plugin install and then click `start using Jenkins`.
5. Click on the `admin` to give new password, then `Configure`, then give new password and `apply` and `save`.
6. Install `piepline` plugins from `Manage jenkins` then `Plugins`.  
7. Select `Available plugins` then search for `pipeline` and `pipeline:Stage View` plugins then install without restart.
8. After installing done select `Go back to the top page`.

OR
### Install Jenkins User
#! /bin/bash
url=http://localhost:8080
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

alias python=python3

#### NEW ADMIN CREDENTIALS URL ENCODED USING PYTHON
username=$(python -c "import urllib.parse;print(urllib.parse.quote(input(), safe=''))" <<< "admin")
new_password=$(python -c "import urllib.parse;print(urllib.parse.quote(input(), safe=''))" <<< "admin")
fullname=$(python -c "import urllib.parse;print(urllib.parse.quote(input(), safe=''))" <<< "NubeEra")
email=$(python -c "import urllib.parse;print(urllib.parse.quote(input(), safe=''))" <<< "admin@gmail.com")

#### GET THE CRUMB AND COOKIE
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "admin:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

#### MAKE THE REQUEST TO CREATE AN ADMIN USER
curl -X POST -u "admin:$password" $url/setupWizard/createAdminUser \
        -H "Connection: keep-alive" \
        -H "Accept: application/json, text/javascript" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "$full_crumb" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --cookie $cookie_jar \
        --data-raw "username=$username&password1=$new_password&password2=$new_password&fullname=$fullname&email=$email&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22fullname%22%3A%20%22$fullname%22%2C%20%22email%22%3A%20%22$email%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22fullname%22%3A%20%22$fullname%22%2C%20%22email%22%3A%20%22$email%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"

### Configure Jenkins URL
#! /bin/bash
url=http://localhost:8080

user=admin
password=admin

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

#### MAKE THE REQUEST TO DOWNLOAD AND INSTALL REQUIRED MODULES
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/json' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "{'dynamicLoad':true,'plugins':['cloudbees-folder','antisamy-markup-formatter','build-timeout','credentials-binding','timestamper','ws-cleanup','ant','gradle','workflow-aggregator','github-branch-source','pipeline-github-lib','pipeline-stage-view','git','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer'],'Jenkins-Crumb':'$only_crumb'}"


### Install Recommended Plugins
#! /bin/bash
url=http://localhost:8080

user=admin
password=admin

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO DOWNLOAD AND INSTALL REQUIRED MODULES
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/json' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "{'dynamicLoad':true,'plugins':['cloudbees-folder','antisamy-markup-formatter','build-timeout','credentials-binding','timestamper','ws-cleanup','ant','gradle','workflow-aggregator','github-branch-source','pipeline-github-lib','pipeline-stage-view','git','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer'],'Jenkins-Crumb':'$only_crumb'}"



## Create Jenkins Job
Create new jenkins job using `pipeline` and add the following configration in `script` section
```
pipeline {
    agent any
    stages {
        stage("Clone Code"){
            steps{
                git branch: 'main', url: 'https://github.com/Osamah999/Jenkins-CI.git'
            }
        }
        stage("Build Code"){
            steps{
                sh "mvn clean package"
            }
        }
        stage("Deploy Code"){
            steps{
                sh "cp -r /var/lib/jenkins/workspace/CI-Job/target/Medicure-1.0-SNAPSHOT /opt/tomcat/webapps/"
            }
        }
    }
}
```
change the `Clone Code` stage with your `Github` url repository.
Before build the job change the permission of the `/opt` directory to allow jenkins user to copy the files to tomcat server
```
cd /
sudo chmod 777 -R /opt
```
To build the job automatically in every changes made to github repository use the `Poll SCM` to check the code every minute
```
* * * * *
```
## Test the hosting
To see the running application open the browser and type `http://localhost:8082`, then `Manage App` the username and password is `admin` for both, then click on `Medicure-1.0-SNAPSHOT`
