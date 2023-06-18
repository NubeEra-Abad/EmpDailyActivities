# Continuous Integration using Jenkins

## Installing tools
First we need to install `Jenkins` and `Maven`
```
sudo apt update

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install fontconfig openjdk-11-jre
sudo apt-get install jenkins

sudo apt-get install maven
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

## Configuration Jenkins
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
change the `Clone Code` with url `Github` repository
before build the job change the permission of the `/opt` directory to allow jenkins user to copy the files to tomcat server
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
