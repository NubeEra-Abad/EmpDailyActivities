# Jenkins master-slave building demo EC2:

### Open your AWS EC2 Dashboard.
1. Create Jenkin_Server instance `(Master)`.
2. Create Build_Server instance `(Slave)`.
3. Connect to the systems using `ssh`.

### Install same java version in both systems
1. Amazon-linux-extras install java-openjdk11
2. Check Java (JDK) version: `java --version`

### Install Jenkins in Jenkins_Server:
```
sudo yum install jenkins
```
### Start Jenkins: 
```
sudo systemctl start jenkins
```
### Open jenkins in port `8080` to config `slave system`.

### Go  to Manage Nodes: 
`Manage Jenkins` --> `Manage Nodes` and `Clouds` --> `New Node`
```
1. Write the name and choose permanent Agent.
2. Number of executors: 2
3. Remote root directory: /opt/build
4. Labels: slave1-build-node
5. Usage:Use this node as much as possible
6. Launch method: Launch agent by connecting it to the master 
7. Custom WorkDir path: custom Remoting work directory will be used instead of the Agent Root Directory

8. Use WebSocket [x]
   - Availability: Keep this agent online as much as possible
```
`Apply` and `save` it.

### Update public IP address:
`Manage jenkins` --> `Configure System` --> Update the `IP`

### Go to Agent slave1-node 
1. Install `agent.jar` file.
2. Copy the command from Agent slave1-node:
```
nohup java -jar agent.jar -jnlpUrl http://107.22.153.134:8080/manage/computer/slave1/jenkins-agent.jnlp -secret 28f5a06868415b00bf7994c43c28742b4ed0ca601527f1c78848661417fa5bb7 -workDir "/opt/build" &
```
3. Check if Agent is connected.

### To test it: Create a new job
`Name`: demo-job --> `Freestyle project` --> `Ok`
 Restric where this project can be run: `slave1`
`Build` --> `Execute shell` --> uptime
 		                     		echo $WORKSPACE

`Apply` and `save` it

#### In Build_Server: type command `uptime` 

## Test new job:
#### Check job consalt output and compare the time
