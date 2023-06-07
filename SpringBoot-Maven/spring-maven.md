## Install Java and Maven
```
sudo apt update
sudo apt install default-jdk
java -version
sudo apt install maven
mvn -version
```
## Set up a Maven project
This command creates a new Maven project with the artifact ID "helloworld" under the "com.example" package.
```
mvn archetype:generate -DgroupId=com.example -DartifactId=helloworld -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```
## Add Spring Boot parent and dependencies
Open the generated `pom.xml` file in a text editor. Add the Spring Boot packages parent within the `<parent>` and dependencies within the `<dependencies>` section:
```
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
```
Save the changes to the `pom.xml` file.
## Create a Spring Boot application class
Create a new Java class called `HelloWorldApplication.java` under the `src/main/java/com/example` directory. Open the file in a text editor and add the following code:
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
        return "Hello, World!";
    }
}
```
## Build and run the application
Open a terminal and navigate to the root directory of your project (where the `pom.xml` file is located). Run the following command to build and run the Spring Boot application:
```
mvn spring-boot:run
```
## Test the application
Open a web browser and visit `http://localhost:8080` to access the running Spring Boot application. You should see the `"Hello, World!"` message displayed in the browser.
You can test the application after see the following output:
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.5.0)

2023-05-30 11:23:54.500  INFO 6610 --- [           main] com.example.HelloWorldApplication        : Starting HelloWorldApplication using Java 11.0.19 on 113aaed071af with PID 6610 (/home/spring/helloworld/target/classes started by root in /home/spring/helloworld)
2023-05-30 11:23:54.502  INFO 6610 --- [           main] com.example.HelloWorldApplication        : No active profile set, falling back to default profiles: default
2023-05-30 11:23:54.982  INFO 6610 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2023-05-30 11:23:54.988  INFO 6610 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2023-05-30 11:23:54.988  INFO 6610 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.46]
2023-05-30 11:23:55.028  INFO 6610 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2023-05-30 11:23:55.028  INFO 6610 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 486 ms
2023-05-30 11:23:55.230  INFO 6610 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2023-05-30 11:23:55.237  INFO 6610 --- [           main] com.example.HelloWorldApplication        : Started HelloWorldApplication in 0.995 seconds (JVM running for 1.181)
2023-05-30 11:23:55.238  INFO 6610 --- [           main] o.s.b.a.ApplicationAvailabilityBean      : Application availability state LivenessState changed to CORRECT
2023-05-30 11:23:55.239  INFO 6610 --- [           main] o.s.b.a.ApplicationAvailabilityBean      : Application availability state ReadinessState changed to ACCEPTING_TRAFFIC
```
This show that the `embedded Tomcat server` is running and you can access it by typing `http://localhost:8080` in the browser. To stop the running server and get back to the terminal use `ctl+c`. To re-run the server use `mvn spring-boot:run` command.
> `mvn clean` used to clean the current maven building and remove target directory. 
