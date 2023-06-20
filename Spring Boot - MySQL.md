# Install Java and Maven
```
sudo apt update
sudo apt install default-jdk
java -version
sudo apt install maven
mvn -version
sudo apt install mysql-server
sudo systemctl start mysql
```
# Set up a Maven project

This command creates a new Maven project with the artifact ID `spring-mysql` under the `com.example` package.
```
mvn archetype:generate -DgroupId=com.example -DartifactId=spring-mysql -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

## Set up the project structure and dependencies

### Add the following dependencies in the pom.xml file:
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

  ####  Open a terminal or command prompt.
  ####  Connect to the MySQL server using the command line:
```
mysql -u username -p
```

#### 1. Replace `username` with your `MySQL username`. 
#### 2. You will be prompted to enter your `MySQL password`.
#### 3. Create a new `database`.

## CREATE DATABASE booksdb;

   ### Switch to the newly created database

#### USE booksdb;

   ##### Create a table called book with the desired fields
```
CREATE TABLE book (id INT AUTO_INCREMENT PRIMARY KEY,book_name VARCHAR(50),isbn_number VARCHAR(50));
```
 #####   Verify that the table was created successfully

#### DESCRIBE book;

   ##### To add data to the table, use the INSERT INTO statement followed by the table name and the column names
```
INSERT INTO book (id, book_name, isbn_number) VALUES (1, 'ABC', '12345');
```
 #####   Confirm that the data has been added to the table by running a SELECT query
```
SELECT * FROM book;
```
  #####  Exit the MySQL prompt
```
exit
```

## Configure MySQL database connection

### Open the application.properties file in `src/main/reresources` and add the following configuration:
```
spring.jpa.hibernate.ddl-auto=update
spring.datasource.url=jdbc:mysql://localhost:3306/<your-database-name>?serverTimezone=UTC&useSSL=false&autoReconnect=true
spring.datasource.username=<your-username>
spring.datasource.password=<your-password>
server.port=8082
connected with MySQL
```
## Create java classes

  ###  SampleAccessingOfMysqlApplication.java
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
  ###  Book.java
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

###    BookRepository.java
```
package com.example;
import org.springframework.data.repository.CrudRepository;
  
// This will be AUTO IMPLEMENTED by Spring
// into a Bean called Book
// CRUD refers Create, Read, Update, Delete
public interface BookRepository extends CrudRepository<Book, Integer> {
  
}
```

###    BookController.java
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

## Test the application

Open a web browser and visit http://localhost:8082/geek/books to access the running Spring Boot application.
You should see data in JSON Format in the browser. You can test the application after see the following output.
