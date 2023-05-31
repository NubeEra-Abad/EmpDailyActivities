## Install Java and Maven
```
sudo apt update
sudo apt install default-jdk
java -version
sudo apt install maven
mvn -version
```
## Set up a Maven project
This command creates a new Maven project with the artifact ID `"my-spring-app"` under the "com.example" package.
```
mvn archetype:generate -DgroupId=com.example -DartifactId=my-spring-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```
## Add Spring Boot parent and dependencies
Open the generated `pom.xml` file in a text editor. Add the Spring Boot packages parent within the `<parent>` and dependencies within the `<dependencies>` sectio>
```
 <!-- Spring Boot parent -->
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
    <!-- Spring Boot dependencies -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
      <version>2.5.0</version>
    </dependency>
    <!-- H2 Database dependency -->   
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <scope>runtime</scope>
    </dependency>
    <!-- JSON processing dependency -->
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
    </dependency>
  </dependencies>
```
Save the changes to the `pom.xml` file.
## Create a Spring Boot application class
Create a new Java class called `MySpringAppApplication.java` under the `src/main/java/com/example` directory. Open the file in a text editor and add the following code:
```
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MySpringAppApplication {
    public static void main(String[] args) {
        SpringApplication.run(MySpringAppApplication.class, args);
    }
}
```
## Create a Model Class
Create a Java class, for example `College.java`, in the `src/main/java/com/example` directory to represent your data model:
```
package com.example;

import java.util.ArrayList;
import java.util.List;

public class College {
    private String name;
    private List<Course> courses;

    public College(String name) {
        this.name = name;
        this.courses = new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Course> getCourses() {
        return courses;
    }

    public void addCourse(Course course) {
        courses.add(course);
    }
}

class Course {
    private String name;
    private String code;
    private List<Student> students;

    public Course(String name, String code) {
        this.name = name;
        this.code = code;
        this.students = new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public List<Student> getStudents() {
        return students;
    }

    public void addStudent(Student student) {
        students.add(student);
    }
}

class Student {
    private String name;
    private String rollNo;
    private int age;

    public Student(String name, String rollNo, int age) {
        this.name = name;
        this.rollNo = rollNo;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRollNo() {
        return rollNo;
    }

    public void setRollNo(String rollNo) {
        this.rollNo = rollNo;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
```
## Create a Controller
Create a Java class, for example `PersonController.java`, in the `src/main/java/com/example` directory to handle `HTTP requests`:
```
package com.example;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PersonController {

    @GetMapping("/data")
    public College[] getData() {
        College college1 = new College("ABC College");
        College college2 = new College("XYZ College");

        Course course1 = new Course("Computer Science", "CS101");
        Course course2 = new Course("Mathematics", "MATH201");

        Student student1 = new Student("John Doe", "001", 20);
        Student student2 = new Student("Jane Smith", "002", 21);
        Student student3 = new Student("Mike Johnson", "003", 19);

        course1.addStudent(student1);
        course1.addStudent(student2);
        course2.addStudent(student3);

        college1.addCourse(course1);
        college1.addCourse(course2);

        college2.addCourse(course1);
        college2.addCourse(course2);


	College[] colleges = {college1, college2};
        return colleges;
    }
}
```
## Build and run the application
Open a terminal and navigate to the root directory of your project (where the `pom.xml` file is located). Run the following command to build and run the Spring Boot application:
```
mvn spring-boot:run
```
## Access the Endpoints
Open a web browser and visit `http://localhost:8080/data` to access the running Spring Boot application. You should see data in `JSON Format` in the browser.
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
This show that the `embedded Tomcat server` is running and you can access it by typing `http://localhost:8080/data` in the browser. To stop the running server and get back to the terminal use `ctl+c`. To re-run the server use `mvn spring-boot:run` command.
> `mvn clean` used to clean the current maven building and remove target directory. 

