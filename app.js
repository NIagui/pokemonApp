const express = require('express');
const mysql = require('mysql2');
var bodyParser = require('body-parser')

const app = express();
const port = 3000;
const cors = require('cors');


app.use((req, res, next) => {
    console.log(`Received ${req.method} request for ${req.url}`);
    next();
});

app.use(cors());
var handlebars = require('express-handlebars').create({
    defaultLayout:'main',
    });
app.use(express.json());
app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.use(bodyParser.urlencoded({extended:true}));
app.use(express.static('public'));


const connection = mysql.createPool({
    host  : 'classmysql.engr.oregonstate.edu',
    user  : 'cs340_shumt',
    password: '5141',
    database: 'cs340_shumt'
});

connection.getConnection(error => {
    if (error) {
        console.error('Error connecting to the database:', error);
        return;
    }
    console.log('Connected to the MySQL database.');
});


// Define a route to get trainers
app.get('/trainers', (req, res) => {
    console.log('executing get trainers');
    connection.query('SELECT * FROM Trainer', (error, results) => {
        if (error) {
            console.log('Error executing query: ', error)
            res.status(500).send('Error executing query');
            return;
        }
        console.log('OK');
        res.json(results);
    });
});

// Define a route to add a trainer
app.post('/addTrainer', (req, res) => {
    const { TrainerName, Location } = req.body;
    const procedure = 'CALL addTrainer(?, ?)';
    connection.query(procedure, [TrainerName, Location], (error, results) => {
        if (error) {
            console.error({error: error.sqlMessage});
            res.status(500).send({error: error.sqlMessage});
            return;
        }
        res.status(201).send('Trainer added successfully');
    });
});


// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
