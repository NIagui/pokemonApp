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


// Define a route to delete a trainer
app.delete('/deleteTrainer/:id', (req, res) => {
    const trainerID = req.params.id;
    const deleteTrainerQuery = 'DELETE FROM Trainer WHERE TrainerID = ?';

    connection.query(deleteTrainerQuery, [trainerID], (error, results) => {
        if (error) {
            console.error('Error executing query:', error.sqlMessage);
            res.status(500).send({ error: error.sqlMessage });
            return;
        }
        if (results.affectedRows === 0) {
            res.status(404).send({ error: 'Trainer not found' });
        } else {
            res.status(200).send('Trainer deleted successfully');
        }
    });
});


// Define a route to update a trainer
app.put('/updateTrainer/:id', (req, res) => {
    const trainerID = req.params.id;
    const { TrainerName, Location } = req.body;
    const updateTrainerQuery = 'UPDATE Trainer SET TrainerName = ?, Location = ? WHERE TrainerID = ?';

    connection.query(updateTrainerQuery, [TrainerName, Location, trainerID], (error, results) => {
        if (error) {
            console.error('Error executing query:', error.sqlMessage);
            res.status(500).send({ error: error.sqlMessage });
            return;
        }
        if (results.affectedRows === 0) {
            res.status(404).send({ error: 'Trainer not found' });
        } else {
            res.status(200).send('Trainer updated successfully');
        }
    });
});

// Add ability to see any given trainer's owned pokemon
app.get('/trainers/:id/pokemon', (req, res) => {
    const trainerID = req.params.id;
    connection.query('SELECT * FROM Pokemon WHERE TrainerID = ?', [trainerID], (error, results) => {
        if (error) {
            console.error('Error fetching Pokémon for trainer:', error);
            res.status(500).send('Error fetching Pokémon for trainer');
            return;
        }
        res.json(results);
    });
});

// Allows user to see the badges owned by a given trainer.
app.get('/trainers/:id/badges', (req, res) => {
    const trainerID = req.params.id;
    const query = `
        SELECT B.BadgeName, A.DateEarned
        FROM Awarded A
        JOIN Badges B ON A.BadgeName = B.BadgeName
        WHERE A.TrainerID = ?`;
    connection.query(query, [trainerID], (error, results) => {
        if (error) {
            console.error('Error fetching badges for trainer:', error);
            res.status(500).send('Error fetching badges for trainer');
            return;
        }
        res.json(results);
    });
});

app.get('/gyms', (req, res) => {
    connection.query('SELECT * FROM Gym', (err, results) => {
        if (err) {
            res.status(500).send(err);
            return;
        }
        res.json(results);
    });
});

// Route to add a gym
app.post('/gyms', (req, res) => {
    const { GymName, Location, SpecialtyType, BadgeName } = req.body;
    connection.query('INSERT INTO Gym (GymName, Location, SpecialtyType, BadgeName) VALUES (?, ?, ?, ?)', [GymName, Location, SpecialtyType, BadgeName], (err, result) => {
        if (err) {
            console.error(err)
            res.status(500).send(err);
            return;
        }
        res.status(201).json({ message: 'Gym added successfully', gymId: result.insertId });
    });
});


// Route to get all Pokémon
app.get('/pokemon', (req, res) => {
    connection.query('SELECT * FROM Pokemon', (err, results) => {
        if (err) {
            res.status(500).send(err);
            return;
        }
        res.json(results);
    });
});

// Route to add a Pokémon
app.post('/pokemon', (req, res) => {
    const { Pokedex, PokemonName, Type, Level, TrainerID, GymName } = req.body;
    connection.query('INSERT INTO Pokemon (Pokedex, PokemonName, Type, Level, TrainerID, GymName) VALUES (?, ?, ?, ?, ?, ?)', [Pokedex, PokemonName, Type, Level, TrainerID, GymName], (err, result) => {
        if (err) {
            console.error(err)
            res.status(500).send(err);
            return;
        }
        res.status(201).json({ message: 'Pokemon added successfully', pokemonId: result.insertId });
    });
});

// Route to delete a Pokémon
app.delete('/pokemon/:id', (req, res) => {
    const pokemonID = req.params.id;
    connection.query('DELETE FROM Pokemon WHERE PokemonID = ?', [pokemonID], (err, results) => {
        if (err) {
            console.error('Error executing query:', err.sqlMessage);
            res.status(500).send({ error: err.sqlMessage });
            return;
        }
        if (results.affectedRows === 0) {
            res.status(404).send({ error: 'Pokemon not found' });
        } else {
            res.status(200).send('Pokemon deleted successfully');
        }
    });
});

// Route to update a Pokémon
app.put('/pokemon/:id', (req, res) => {
    const pokemonID = req.params.id;
    const { Pokedex, PokemonName, Type, Level, TrainerID, GymName } = req.body;
    const updatePokemonQuery = 'UPDATE Pokemon SET Pokedex = ?, PokemonName = ?, Type = ?, Level = ?, TrainerID = ?, GymName = ? WHERE PokemonID = ?';
    connection.query(updatePokemonQuery, [Pokedex, PokemonName, Type, Level, TrainerID, GymName, pokemonID], (err, results) => {
        if (err) {
            console.error('Error executing query:', err.sqlMessage);
            res.status(500).send({ error: err.sqlMessage });
            return;
        }
        if (results.affectedRows === 0) {
            res.status(404).send({ error: 'Pokemon not found' });
        } else {
            res.status(200).send('Pokemon updated successfully');
        }
    });
});







// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
