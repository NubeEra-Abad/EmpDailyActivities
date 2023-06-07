

# 1.Setup Tomcat Server
	- Setup a Linux EC2 Instance
	- Install Java
	- Download and configure Tomcat
	- Start Tomcat Server
	- Access Web UI on port 8080

# 2. Integrate Tomcat with Jenkins
	- Install “Deploy to container”
	- Configure tomcat server with Credentials

# 3. Integrate Docker with Jenkins
	- Setup a Linux EC2 Instance
	- Install docker
	- Start docker services
	- Create a dockeradmin user
	- Add Dockerhost to Jenkins “configure systems”
	- Install “Publish Over SSH” plugin

# 4. Create Dockerfile
	FROM centos
	RUN yum -y install java
	RUN mkdir /opt/tomcat/
	WORKDIR /opt/tomcat
	ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.54.tar.gz /opt/tomcat
	RUN tar xvfz apache*.tar.gz
	RUN mv apache-tomcat-9.0.54/* /opt/tomcat
	EXPOSE 8080
	CMD ["/opt/tomcat/bin/catalina.sh", "run"]



	

