## Install Java and Maven
```
sudo apt update
sudo apt install default-jdk
java -version
sudo apt install maven
mvn -version
sudo apt install mysql-server
sudo systemctl start mysql
```
## Set up a Maven project
This command creates a new Maven project with the artifact ID `"spring-mysql"` under the "com.example" package.
```
mvn archetype:generate -DgroupId=com.example -DartifactId=spring-mysql -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```
## Set up the project structure and dependencies
Add the following dependencies in the `pom.xml` file:
```
<parent>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-parent</artifactId>
	<version>2.7.12</version>
	<relativePath/> <!-- lookup parent from repository -->
</parent>
<dependencies>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-data-jpa</artifactId>
	</dependency>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-web</artifactId>
	</dependency>

	<dependency>
		<groupId>com.mysql</groupId>
		<artifactId>mysql-connector-j</artifactId>
		<scope>runtime</scope>
	</dependency>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-test</artifactId>
		<scope>test</scope>
	</dependency>
</dependencies>

<build>
	<plugins>
		<plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
		</plugin>
	</plugins>
</build>
```
## Create MySql Database
1. Open a terminal or command prompt.
2. Connect to the MySQL server using the command line:
```
mysql -u root -p
```
3. Add new user
The following command will add a new user with username `abc_user` and password `abc123` 
```
update user set authentication_string=password('abc123') where user='abc_user';
```
4. Flush the privileges to reload the grant tables
```
flush privileges;
```
5. Exit the MySQL prompt
```
exit
```
7. Restart MySQL
```
sudo systemctl restart mysql
```
8. Login again with the new mysql user
```
mysql -u abc_user -p
```
9. Create a new database and name it `booksdb`
```
CREATE DATABASE booksdb;
```
10. Switch to the newly created database
```
USE booksdb;
```
11. Create a table called `book` with the desired fields
```
CREATE TABLE book (id INT AUTO_INCREMENT PRIMARY KEY,book_name VARCHAR(50),isbn_number VARCHAR(50));
```
12. Verify that the table was created successfully
```
DESCRIBE book;
```
13. To add data to the table, use the INSERT INTO statement followed by the table name and the column names
```
INSERT INTO book (id, book_name, isbn_number) VALUES (1, 'ABC', '12345');
INSERT INTO book (id, book_name, isbn_number) VALUES (2, 'XYZ', '54321');
INSERT INTO book (id, book_name, isbn_number) VALUES (3, 'QWE', '56789');
```
14. Confirm that the data has been added to the table by running a `SELECT` query
```
SELECT * FROM book;
```
15. Exit the MySQL prompt
```
exit
```
## Configure MySQL database connection
Open the `application.properties` file in `src/main/reresources` and add the following configuration:
```
spring.jpa.hibernate.ddl-auto=update
spring.datasource.url=jdbc:mysql://localhost:3306/booksdb?serverTimezone=UTC&useSSL=false&autoReconnect=true
spring.datasource.username=abs_user
spring.datasource.password=abc123
server.port=8082
connected with MySQL
```
in this configuration the database name is `booksdb`, username is `abc_user`, and the password is `abc123`.
## Create java classes
1. `SampleAccessingOfMysqlApplication.java`
```
package com.example;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
  
@SpringBootApplication
public class SampleAccessingOfMysqlApplication {
    public static void main(String[] args) {
        SpringApplication.run(SampleAccessingOfMysqlApplication.class, args);
    }
}
```
2. `Book.java`
```
package com.example;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
  
// This tells Hibernate to make
// a table out of this class
@Entity 
public class Book {
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Integer id;
  
    private String bookName;
  
    private String isbnNumber;
  
    public String getBookName() {
        return bookName;
    }
  
    public void setBookName(String bookName) {
        this.bookName = bookName;
    }
  
    public String getIsbnNumber() {
        return isbnNumber;
    }
  
    public void setIsbnNumber(String isbnNumber) {
        this.isbnNumber = isbnNumber;
    }
  
    public Integer getId() {
        return id;
    }
  
    public void setId(Integer id) {
        this.id = id;
    }
      
}
```
3. `BookRepository.java`
```
package com.example;
import org.springframework.data.repository.CrudRepository;
  
// This will be AUTO IMPLEMENTED by Spring
// into a Bean called Book
// CRUD refers Create, Read, Update, Delete
public interface BookRepository extends CrudRepository<Book, Integer> {
  
}
```
4. `BookController.java`
```
package com.example;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
  
// This means that this 
// class is a Controller
@Controller    
  
// This means URL's start with /geek (after Application path)
@RequestMapping(path="/geek") 
public class BookController {
    
    // This means to get the bean called geekuserRepository
    // Which is auto-generated by Spring, we will use it
      // to handle the data
    @Autowired 
    private BookRepository bookRepository;
  
    // Map ONLY POST Requests
    @PostMapping(path="/addbook") 
    public @ResponseBody String addBooks (@RequestParam String bookName
            , @RequestParam String isbnNumber) {
        
        // @ResponseBody means the returned String
          // is the response, not a view name
        // @RequestParam means it is a parameter
          // from the GET or POST request
        
        Book book = new Book();
        book.setBookName(bookName);
        book.setIsbnNumber(isbnNumber);
        bookRepository.save(book);
        return "Details got Saved";
    }
  
    @GetMapping(path="/books")
    public @ResponseBody Iterable<Book> getAllUsers() {
        // This returns a JSON or XML with the Book
        return bookRepository.findAll();
    }
}
```
## Build and run the application
Open a terminal and navigate to the root directory of your project (where the `pom.xml` file is located). Run the following command to build and run the Spring Boot application:
```
mvn spring-boot:run
```
## Test the application
Open a web browser and visit `http://localhost:8082/geek/books` to access the running Spring Boot application. You should see data in `JSON Format` in the browser.
You can test the application after see the following output:
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::               (v2.7.12)

2023-06-04 18:16:41.055  INFO 66796 --- [           main] c.e.d.SampleAccessingOfMysqlApplication  : Starting SampleAccessingOfMysqlApplication using Java 17.0.6 on kali with PID 66796 (/home/kali/Demo/demo/target/classes started by root in /home/kali/Demo/demo)
2023-06-04 18:16:41.057  INFO 66796 --- [           main] c.e.d.SampleAccessingOfMysqlApplication  : No active profile set, falling back to 1 default profile: "default"
2023-06-04 18:16:41.430  INFO 66796 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
2023-06-04 18:16:41.458  INFO 66796 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 23 ms. Found 1 JPA repository interfaces.
2023-06-04 18:16:41.784  INFO 66796 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8082 (http)
2023-06-04 18:16:41.790  INFO 66796 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2023-06-04 18:16:41.791  INFO 66796 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.75]
2023-06-04 18:16:41.855  INFO 66796 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2023-06-04 18:16:41.855  INFO 66796 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 762 ms
2023-06-04 18:16:41.968  INFO 66796 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2023-06-04 18:16:41.995  INFO 66796 --- [           main] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.6.15.Final
2023-06-04 18:16:42.099  INFO 66796 --- [           main] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
2023-06-04 18:16:42.157  INFO 66796 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2023-06-04 18:16:42.261  INFO 66796 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2023-06-04 18:16:42.278  INFO 66796 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.MySQL55Dialect
2023-06-04 18:16:42.615  INFO 66796 --- [           main] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2023-06-04 18:16:42.621  INFO 66796 --- [           main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2023-06-04 18:16:42.785  WARN 66796 --- [           main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
2023-06-04 18:16:42.995  INFO 66796 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8082 (http) with context path ''
2023-06-04 18:16:43.002  INFO 66796 --- [           main] c.e.d.SampleAccessingOfMysqlApplication  : Started SampleAccessingOfMysqlApplication in 2.189 seconds (JVM running for 2.404)
2023-06-04 18:17:20.612  INFO 66796 --- [nio-8082-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2023-06-04 18:17:20.612  INFO 66796 --- [nio-8082-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
```
![Screenshot from 2023-06-04 18-51-58](https://github.com/NubeEra-Abad/EmpDailyActivities/assets/79145466/af1e0536-88a8-4a23-8799-6de84a96a221)
## Display MySql table data is working. Add new data to the table using POST method still work on it. 
