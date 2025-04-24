const sqlite3 = require('sqlite3').verbose();

let db = new sqlite3.Database(
  '../database/plantarium.sqlite',
  sqlite3.OPEN_READONLY,
  (err) => {
    if (err) {
      console.error('Error opening database', err.message);
      return;
    }
    console.log('Connected to the plantarium.sqlite database.');
  },
);

// Query to list all tables in the database
const query = `SELECT name FROM sqlite_master WHERE type='table'`;

db.serialize(() => {
  db.all(query, [], (err, rows) => {
    if (err) {
      console.error('Error executing query', err.message);
      return;
    }
    console.log('Tables in the database:', rows);
  });
});

// Close the database connection
db.close((err) => {
  if (err) {
    console.error(err.message);
  }
  console.log('Closed the database connection.');
});
