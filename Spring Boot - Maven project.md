# Spring Boot - Maven:

## Install Java and Maven:
```
sudo apt update
sudo apt install default-jdk
java -version
sudo apt install maven
mvn -version
```
## Set up Maven project:
```
mvn archetype:generate -DgroupId=com.example -DartifactId=helloworld -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```
## Type commands:
```
cd /home/x/helloworld
nano pom.xml
```
## Add Spring Boot parent and dependencies:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-ins>
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>helloworld</artifactId>
  <packaging>jar</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>helloworld</name>
  <url>http://maven.apache.org</url>
  <parent>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-parent</artifactId>
      <version>2.5.0</version>
  </parent>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
      <version>2.5.0</version>
    </dependency>
  </dependencies>
</project>
```
## Type commands:
From helloworld dir:
```
cd src/main/java/com/example
nano HelloWorldApplication.java 
```
```
package com.example;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
@SpringBootApplication
@RestController
public class HelloWorldApplication {
    public static void main(String[] args) {
        SpringApplication.run(HelloWorldApplication.class, args);
    }
    @GetMapping("/")
    public String hello() {
        return "Hello Mr. Mohd Hassan";
    }
}
```
## Build and run the application:
```
mvn spring-boot:run
```
## Test the application:
Open a web browser http://localhost:8080

Output: `Hello Mr. Mohd Hassan`
