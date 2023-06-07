

# 1. Prepare Ansible Server
	- Setup EC2 instance
	- Install ansible
	- Setup hostname
	- Create ansadmin user
	- Add user to sudoers file
	- Generate ssh keys
	- Enable password based login

# 2. Manage DockerHost with Ansible
- On Docker Host
	- Create ansadmin user
	- Add ansadmin to sudoers files
	- Enable password based lodin

- On Ansible Node
	- Add to hosts file
	- Copy ssh keys
	- Test the connection 

# 3. Integrate Ansible with Jenkins

# 4. Deploy Ansible playbook
	- Remove existing container
	- Remove existing image
	- Create new container

# 5. Copy Image on to DockerHub 

# 6. Jenkins Job to build an image onto ansible

# 7. Run the hosted web page on tomcat server on docker container
