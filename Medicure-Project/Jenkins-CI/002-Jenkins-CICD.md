# Installation
For this job we need for two AWS instance, one for `Jenkins` and `Maven`, and the second instance for `Docker`, `Ansible` and `Tomcat container`.
For installing `Jenkins` and `Maven` you can follow the instructions in [001-Jenkins-Maven](https://github.com/NubeEra-Abad/EmpDailyActivities/blob/Osamah999/Medicure-Project/Jenkins-CI/001-Jenkins-Maven.md)
and you need to open port no `8080` in `AWS Security Group`

## AWS instance and user setup
For this we need ubuntu instance with open port no `8082` for tomcat container.
1. After creating instance, we need to create user for ansible in this example I named it as `ansadmin`, for that switch to root user
```
sudo su - 

apt update
adduser ansadmin

```
It will prompt you to give password and some information, give password and keep other things empty by clicking `Enter`.
It will show you output like this
```
Adding user `ansadmin' ...
Adding new group `ansadmin' (1001) ...
Adding new user `ansadmin' (1001) with group `ansadmin' ...
Creating home directory `/home/ansadmin' ...
Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for ansadmin
Enter the new value, or press ENTER for the default
	Full Name []: 
	Room Number []: 
	Work Phone []: 
	Home Phone []: 
	Other []: 
Is the information correct? [Y/n] y
```
2. Grant root permissions for the new user, Use `visudo` to edit the sudoers file using root user.
Add the newly created user by inserting `<username> ALL=(ALL:ALL) ALL` at the end of the user privilege section, as shown in the following example:
```
# User privilege specification
root    ALL=(ALL:ALL) ALL
ansadmin ALL=(ALL:ALL) ALL
```
Use `su` followed by the `<username>` to switch to the new user.

3. Give SSH access for the new ansible user.
   - using `ansadmin user` create ssh-key using `ssh-keygen`
   - login to `ubuntu user` and copy the content of `~/.ssh/authorized_keys`, it contain key for allowing access to the current `AWS instance` using `key.pem`
   - login back to `ansadmin user` and create `authorized_keys` file in `~/.ssh/` and paste the copied key.

## Installing Docker and Ansible
```
sudo apt update
sudo apt install docker.io -y
sudo apt install ansible -y
```
After installing Docker and Ansible, we need to add the created Ansible user to `Docker group` to let it execute docker commands 
```
sudo groupadd docker
sudo usermod -aG docker ansadmin
```
Make the changes effective by `re-starting docker`
```
sudo systemctl restart docker
```
Then we need to `login` to `DockerHub` for push and pull images.
```
docker login
```
give your DockerHub `username` and `password`

3. For allowing `asnadmin` execute ansible.yml files, add the `ansadmin` to `/etc/ansible/hosts`
```
sudo nano /etc/ansible/hosts
```
```
[ansadmin]
<aws-instance-privateId>
```
If the `/ansibel/hosts` not exist, then create it manually, first create `ansible` directory then `hosts` file.

## Ansible files and Dockerfile
1. switch to `ansdmin` user.
2. In the home directory create new directory and name it `docker` without using `sudo` to make the owner of this directory `ansadmin user` not `root user`
```
mkdir docker
```
3. Go inside `docker` directory.
4. Inside docker directory create `Dockerfile` without `sudo` and add the following:
```
FROM tomcat:9.0.58-jdk17-openjdk-slim
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps/

# Comment lines 21 and 22 in context.xml
RUN sed -i '21,22 s/^/<!-- /; 21,22 s/$/ -->/' /usr/local/tomcat/webapps/host-manager/META-INF/context.xml
RUN sed -i '21,22 s/^/<!-- /; 21,22 s/$/ -->/' /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Add GUI user to config/tomcat-users.xml
RUN sed -i '56i \
	<role rolename="manager-gui"/> \
	<role rolename="admin-gui"/> \
	<role rolename="manager-script"/> \
	<role rolename="manager-jmx"/> \
	<role rolename="manager-status"/> \
	<user username="admin" password="admin" roles="manager-gui,admin-gui,manager-script"/> \
' /usr/local/tomcat/conf/tomcat-users.xml

# Copy war file from server to Tomcat container
COPY ./*.war /usr/local/tomcat/webapps
```
5. Create `regapp.yml` without `sudo` and add the following:
```
nano regapp.yml
```
```
---
- hosts: ansadmin

  tasks:
  - name: create docker image
    command: docker build -t regapp:latest .
    args:
     chdir: /home/ansadmin/docker

  - name: create tag to push image onto dockerhub
    command: docker tag regapp:latest osamah9/regapp:latest

  - name: push docker image
    command: docker push osamah9/regapp:latest
```
replace `osamah9` with your `DockerHub username` 
6. create `deploy_regapp.yml` without `sudo` and add the following code:
```
---
- hosts: ansadmin

  tasks:
   - name: stop existing container
     command: docker stop regapp-server
     ignore_errors: yes

   - name: remove the container
     command: docker rm regapp-server
     ignore_errors: yes

   - name: remove image
     command: docker rmi osamah9/regapp:latest
     ignore_errors: yes

   - name: remove none images
     command: docker image prune -f
     ignore_errors: yes

   - name: create container
     command: docker run -d --name regapp-server -p 8082:8080 osamah9/regapp:latest
```
7. Now we need to copy the `ansadmin ssh publickey` to the `~/ssh/authorized_keys` using `ansadmin user` for giving access to execute ansible.yml files remotelly.
```
ssh-copy-id localhost
```
Then
```
cd ~/.ssh
cat id_rsa.pub         // Copy the key
nano authorized_keys   // In new line paste the key
```

