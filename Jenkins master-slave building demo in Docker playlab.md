# Jenkins master-slave building demo in Docker lab:

## On Master:
```
apk add openjdk11 
docker pull jenkins/jenkins:lts
docker run -u 0 -d -p 8082:8080 -p 50002:50000 --name jenkins jenkins:latest
docker exec -it cont-name /bin/bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```
### Then Make Node In Jenkins From Manage jenkins

## On Slave: 
```
apk add openjdk11
```
### go in the folder which you opted while making node remote dir `/opt`

### run agent.jar file command:
```
curl -sO http://ip172-18-0-41-chphv409ec4g00esoj7g-8082.direct.labs.play-with-docker.com/jnlpJars/agent.jar

java -jar agent.jar -jnlpUrl http://ip172-18-0-41-chphv409ec4g00esoj7g-8082.direct.labs.play-with-docker.com/manage/computer/ubuntu1/jenkins-agent.jnlp -secret 0749d1c7c7dce63c5e681a70a9e4ae5411c85917ae0a5ca0f52c3a127d4f0736 -workDir "/opt"
```
