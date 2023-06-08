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
