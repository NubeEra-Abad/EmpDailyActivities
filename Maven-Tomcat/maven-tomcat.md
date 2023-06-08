# installation
For deploy maven appliction on tomcat server running in another server we need to install `Maven` and `java-11` in local and `Tomcat` in server
## Installing java-11 and Maven
```
sudo apt update
sudo apt install openjdk-11-jdk
java -version
sudo apt install maven
mvn --version
```
## installing Tomcat in AWS instance
for running Tomcat we need to install java-11 as well
```
sudo su -
apt update
apt install openjdk-11-jdk
cd /opt
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar -xvzf apache-tomcat-9.0.75.tar.gz
mv apache-tomcat-9.0.75 tomcat
```
start the tomcat server
```
cd tomcat/bin
./startip
```
# Tomcat configuration
We need to edit `context.xml` to access manager gui. Comment the following codes in the following files
```
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
-->


nano /opt/tomcat/webapps/host-manager/META-INF/context.xml
nano /opt/tomcat/webapps/manager/META-INF/context.xml

```
## Add username and password
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
# Build Java project using Maven
build java project in the local machine
```
mvn archetype:generate -DgroupId=com.example -DartifactId=my-webapp -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
```
# Configure pom.xml
```
 <build>
    <finalName>webapp</finalName>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-war-plugin</artifactId>
            <version>3.2.3</version>
            <configuration>
                <warSourceDirectory>src/main/webapp</warSourceDirectory>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
            <configuration>
                <source>1.8</source>
                <target>1.8</target>
            </configuration>
        </plugin>
	 <plugin>
    		 <groupId>org.apache.tomcat.maven</groupId>
     		 <artifactId>tomcat7-maven-plugin</artifactId>
    		 <version>2.2</version>
    		 <configuration>
       		 <url>http://<Tomcat-Server>:8080/manager/text</url>
       		 <server>tomcat-remote</server>
       		 <path>/webapp</path>
     		 </configuration>
   	 </plugin>
    </plugins>
  </build>
```
replace `<Tomcat-server>` with your aws instance public IP address. Open a web browser and visit `http://<aws-instance-ip>:8080` to access tomcat home page. 
## Edit the maven `settings.xml` file 
navigate to `/usr/share/maven/conf/` and using `nano` editor open `settings.xml` and add the following codes in `<servers>` section
```
sudo nano /usr/share/maven/conf/settings.xml
```
```
  <servers>
    <server>
         <id>tomcat-remote</id>
         <username>admin</username>
         <password>admin</password>
    </server>
  </servers>
```
## Deploy the project
Open a terminal and navigate to the root directory of your project (where the `pom.xml` file is located). Run the following command to deploy the application on the tomcat server:
```
sudo mvn tomcat7:redeploy
```
## Test the application
Open a web browser and visit `http://<aws-instance-ip>:8080/webapp` to access the running java application. In this project you should see `Hello World!` in the browser.

