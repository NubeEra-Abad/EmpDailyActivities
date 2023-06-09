## Install Node.js

1. Open a terminal.
2. Run the following command to install Node.js and npm:
    ```
    $ sudo apt update
    $ sudo apt install nodejs npm
    ```

## Install MySQL Server

1. Run the following command to install MySQL Server:
    ```
    $ sudo apt install mysql-server
    ```

## Start MySQL Service

1. Run the following command to start the MySQL service:
    ```
    $ sudo service mysql start
    ```

## Create a MySQL Database and User

1. Launch the MySQL command-line tool:
    ```
    $ mysql -u root -p
    ```
   Enter your MySQL root password when prompted.
2. Create a new database:
    ```
    $ CREATE DATABASE mydatabase;
    ```
3. Create a new user and grant privileges:
    ```
    $ CREATE USER 'u1'@'localhost' IDENTIFIED BY '123';
    GRANT ALL PRIVILEGES ON mydatabase.* TO 'myuser'@'localhost';
    FLUSH PRIVILEGES;
    ```

## Select the Database

1. Switch to the created database:
    ```
    $ use mydatabase
    ```

## Create a table in the database

1. Run the following query to create a table named `mytable`:
    ```sql
    CREATE TABLE mytable (
        PersonID int,
        LastName varchar(255),
        FirstName varchar(255),
        Address varchar(255),
        City varchar(255)
    );
    ```

## Insert Query In the table

1. Run the following query to insert a row into the `mytable` table:
    ```sql
    INSERT INTO mytable (PersonID, LastName, FirstName, Address, City)
    VALUES (1, 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006');
    ```

## Create a Node.js Project

1. Create a new directory for your project:
    ```
    $ mkdir my-node-project
    $ cd my-node-project
    ```
2. Initialize a new Node.js project:
    ```
    $ npm init -y
    ```
3. Install the necessary Node.js packages for MySQL integration:
    ```
    $ npm install mysql
    ```

## Create a JavaScript file

1. Create a new file named `app.js` in your project directory.
2. Open the file and add the following code:

    ```javascript
    const mysql = require('mysql');

    // MySQL connection configuration
    const connection = mysql.createConnection({
      host: 'localhost',
      user: 'u1',
      password: '123',
      database: 'mydatabase'
    });

    // Connect to MySQL
    connection.connect((err) => {
      if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
      }
      console.log('Connected to MySQL database');
    });

    // Perform MySQL query
    connection.query('SELECT * FROM mytable', (err, results) => {
      if (err) {
        console.error('Error executing MySQL query:', err);
        return;
      }
      console.log('Query results:', results);
    });

    // Close MySQL connection
    connection.end((err) => {
      if (err) {
        console.error('Error closing MySQL connection:', err);
        return;
      }
      console.log('MySQL connection closed');
    });
    ```

## Run the Node.js Application

1. Save the `app.js` file.
2. Run the Node.js application with the following command:
    ```
    $ node app.js
    ```

---

## Server History - Practical Of Node.js + MySQL Task:

1. Run the following commands to update and install Node.js and npm:
    ```
    $ sudo apt update
    $ sudo apt install nodejs npm
    ```

2. Check the installed Node.js version:
    ```
    $ nodejs --version
    ```

3. Install MySQL Server:
    ```
    $ sudo apt install mysql-server
    ```

4. Check the installed MySQL version:
    ```
    $ mysql --version
    ```

5. Start the MySQL service:
    ```
    $ sudo service mysql start
    ```

6. Check the status of the MySQL service:
    ```
    $ sudo service mysql status
    ```

7. Access the MySQL command-line tool:
    ```
    $ mysql -u root -p
    ```
   Enter your MySQL root password when prompted.

8. Create a new Node.js project directory:
    ```
    $ mkdir my-node-project
    $ cd my-node-project
    ```

9. Initialize a new Node.js project:
    ```
    $ npm init -y
    ```

10. Install the `mysql` package for Node.js:
    ```
    $ npm install mysql
    ```

11. Open the `app.js` file for editing:
    ```
    $ nano app.js
    ```

12. Access the MySQL command-line tool with root user:
    ```
    $ mysql -u root -p
    ```
   Enter your MySQL root password when prompted.

13. Run the Node.js application:
    ```
    $ node app.js
    ```

14. Update the MySQL client:
    ```
    $ sudo apt update
    $ sudo apt install --only-upgrade mysql-client
    ```

15. Modify the MySQL configuration file:
    ```
    $ sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
    ```

16. Restart the MySQL service:
    ```
    $ sudo service mysql restart
    ```

17. Run the Node.js application again:
    ```
    $ node app.js
    ```

18. Access MySQL using the 'u1' user:
    ```
    $ mysql -u u1 -p
    ```

19. Access MySQL using the root user:
    ```
    $ mysql -u root -p
    ```

20. Run the Node.js application:
    ```
    $ node app.js
    ```

21. Access MySQL using the root user:
    ```
    $ mysql -u root -p
    ```

22. Run the Node.js application:
    ```
    $ node app.js
    ```

23. Access MySQL using the root user:
    ```
    $ mysql -u root -p
    ```

24. Run the Node.js application:
    ```
    $ node app.js
    ```
