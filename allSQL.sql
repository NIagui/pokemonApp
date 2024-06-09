-- Table Creation Stage


-- use commands below if you got an error:


-- DROP TABLE IF EXISTS Pokemon;
-- DROP TABLE IF EXISTS Awarded;
-- DROP TABLE IF EXISTS Gym_Leader;
-- DROP TABLE IF EXISTS Gym;
-- DROP TABLE IF EXISTS Badges;
-- DROP TABLE IF EXISTS Trainer;




CREATE TABLE Trainer
(
  TrainerID INT NOT NULL AUTO_INCREMENT,
  TrainerName VARCHAR(50) NOT NULL UNIQUE,
  Location VARCHAR(50) NOT NULL,
  PRIMARY KEY (TrainerID)
);

CREATE TABLE Badges
(
  BadgeName VARCHAR(50) NOT NULL,
  PRIMARY KEY (BadgeName)
);

CREATE TABLE Awarded
(
  DateEarned DATE NOT NULL,
  TrainerID INT NOT NULL,
  BadgeName VARCHAR(50) NOT NULL,
  PRIMARY KEY (TrainerID, BadgeName),
  FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (BadgeName) REFERENCES Badges(BadgeName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Gym
(
  GymName VARCHAR(50) NOT NULL,
  Location VARCHAR(50) NOT NULL,
  SpecialtyType VARCHAR(50) NOT NULL,
  BadgeName VARCHAR(50),
  PRIMARY KEY (GymName),
  FOREIGN KEY (BadgeName) REFERENCES Badges(BadgeName)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE Gym_Leader
(
  LeaderID INT NOT NULL,
  LeaderName VARCHAR(50) NOT NULL,
  GymName VARCHAR(50) NOT NULL,
  PRIMARY KEY (LeaderID),
  FOREIGN KEY (GymName) REFERENCES Gym(GymName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Pokemon
(
  PokemonID INT NOT NULL,
  Pokedex INT NOT NULL,
  PokemonName VARCHAR(50) NOT NULL,
  Type VARCHAR(50) NOT NULL,
  Level INT NOT NULL,
  TrainerID INT,
  GymName VARCHAR(50),
  PRIMARY KEY (PokemonID),
  FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
    ON UPDATE CASCADE,
  FOREIGN KEY (GymName) REFERENCES Gym(GymName)
    ON UPDATE CASCADE
);


-- Population stage

INSERT INTO Trainer (TrainerID, TrainerName, Location) VALUES
(1, 'Ash', 'Pallet Town'),
(2, 'Naruto', 'Konohagakure'),
(3, 'Goku', 'Pallet Town'),
(4, 'Peter Griffin', 'Pewter City'),
(5, 'Jonny Cage', 'Viridian City'),
(6, 'Aj', 'Cerulean City'),
(7, 'CJ', 'Cerulean City'),
(8, 'Sasuke', 'Konohagakure'),
(9, 'Hamster1', 'Blackthorn City'),
(10, 'DESTORYER777','Cinnabar Island'),
(11, 'Goober', 'Pallet Town');


INSERT INTO Badges (BadgeName) VALUES
('Boulder Badge'),
('Cascade Badge'),
('Thunder Badge'),
('Rainbow Badge'),
('Soul Badge'),
('Marsh Badge'),
('Volcano Badge'),
('Earth Badge'),
('Rising Badge'),
('Zephyr Badge');

INSERT INTO Awarded (DateEarned, TrainerID, BadgeName) VALUES
('2024-06-01', 1, 'Boulder Badge'),
('2024-06-01', 1, 'Cascade Badge'),
('2024-06-01', 1, 'Thunder Badge'),
('2024-06-02', 1, 'Rainbow Badge'),
('2024-06-02', 2, 'Boulder Badge'),
('2024-06-03', 2, 'Cascade Badge'),
('2024-06-01', 3, 'Boulder Badge'),
('2024-06-03', 4, 'Cascade Badge'),
('2024-06-02', 5, 'Thunder Badge'),
('2024-06-04', 6, 'Rainbow Badge');

INSERT INTO Gym (GymName, Location, SpecialtyType, BadgeName) VALUES
('Pewter Gym', 'Pewter City', 'Rock', 'Boulder Badge'),
('Cerulean Gym', 'Cerulean City', 'Water', 'Cascade Badge'),
('Vermilion Gym', 'Vermilion City', 'Electric', 'Thunder Badge'),
('Celadon Gym', 'Celadon City', 'Grass', 'Rainbow Badge'),
('Fuchsia Gym', 'Fuchsia City', 'Poison', 'Soul Badge'),
('Saffron Gym', 'Saffron City', 'Psychic', 'Marsh Badge'),
('Cinnabar Gym', 'Cinnabar Island', 'Fire', 'Volcano Badge'),
('Viridian Gym', 'Viridian City', 'Ground', 'Earth Badge'),
('Blackthorn Gym', 'Blackthorn City', 'Dragon', 'Rising Badge'),
('Violet Gym', 'Violet City', 'Flying', 'Zephyr Badge');

INSERT INTO Gym_Leader (LeaderID, LeaderName, GymName) VALUES
(1, 'Brock', 'Pewter Gym'),
(2, 'Misty', 'Cerulean Gym'),
(3, 'Lt. Surge', 'Vermilion Gym'),
(4, 'Erika', 'Celadon Gym'),
(5, 'Koga', 'Fuchsia Gym'),
(6, 'Sabrina', 'Saffron Gym'),
(7, 'Blaine', 'Cinnabar Gym'),
(8, 'Giovanni', 'Viridian Gym'),
(9, 'Clair', 'Blackthorn Gym'),
(10, 'Falkner', 'Violet Gym');

-- PokemonID is the primary key here, not Pokedex#
INSERT INTO Pokemon (PokemonID, Pokedex, PokemonName, Type, Level, TrainerID, GymName) VALUES
(1, 1, 'Bulbasaur', 'Grass/Poison', 5, 1, NULL),
(2, 4, 'Charmander', 'Fire', 5, NULL, 'Cerulean Gym'),
(3, 7, 'Squirtle', 'Water', 5, 2, NULL),
(4, 25, 'Pikachu', 'Electric', 5, 1, NULL),
(5, 39, 'Jigglypuff', 'Normal/Fairy', 5, 3, NULL),
(6, 63, 'Abra', 'Psychic', 5, NULL, 'Saffron Gym'),
(7, 133, 'Eevee', 'Normal', 5, NULL, NULL),
(8, 150, 'Mewtwo', 'Psychic', 70, 5, NULL),
(9, 151, 'Mew', 'Psychic', 30, NULL, NULL),
(10, 143, 'Snorlax', 'Normal', 30, 7, NULL),
(11, 95, 'Onix', 'Rock/Ground', 14, NULL, 'Pewter Gym');






-- Queries stage:

-- CREATE/INSERT:
-- 
CREATE TABLE CHALLENGE
(
    TrainerID INT NOT NULL,
    GymName VARCHAR(50) NOT NULL,
    Date DATE NOT NULL,
    Result VARCHAR(15) NOT NULL, -- won, lost, draw, surrendered
    PRIMARY KEY (TrainerID, GymName, Date),
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID),
    FOREIGN KEY (GymName) REFERENCES Gym(GymName)
);

INSERT INTO CHALLENGE (TrainerID, GymName, Date, Result) VALUES
(1, 'Pewter Gym', '2024-01-01', 'Won'),
(1, 'Cinnabar Gym', '2024-01-01', 'Lost'),
(2, 'Cinnabar Gym', '2024-01-01', 'Lost');


-- RETRIEVE using JOIN
-- This can be used to get gym roster given a boss (gym leader) e.g. Brock. 
SELECT P.PokemonName, P.Type, P.Level, G.GymName
FROM Pokemon P
LEFT JOIN Gym G ON P.GymName = G.GymName
LEFT JOIN Gym_Leader L ON G.GymName = L.GymName
WHERE L.LeaderName = 'Brock';

-- Retrieve using JOIN
-- THis is used to get all the potential challengers of a gym (trainers who shares the same area)
SELECT T.TrainerName, T.Location
FROM Trainer T
INNER JOIN Gym G ON T.Location = G.Location
WHERE G.GymName = 'Pewter Gym';
-- 


-- retrieve using JOIN: use trainer id to 
SELECT T.TrainerName, B.BadgeName, A.DateEarned
FROM Trainer T
INNER JOIN Awarded A ON T.TrainerID = A.TrainerID
INNER JOIN Badges B ON A.BadgeName = B.BadgeName
WHERE T.TrainerName = 'Ash';



-- RETRIEVE using nested query
-- searching for all the Pokemon that Ash has:
-- may be invalid: we don't need to use the trainer name at all
SELECT Pokedex, PokemonName, Type, Level
FROM Pokemon
WHERE TrainerID = 
(
  SELECT TrainerID 
  FROM Trainer 
  WHERE TrainerName = 'Ash'
);

-- RETRIEVE using aggregate function
-- retrieving number of badges of all players 
SELECT T.TrainerName, COUNT(A.BadgeName) as BadgeCount
FROM Awarded A JOIN Trainer T ON A.TrainerID = T.TrainerID
GROUP BY T.TrainerID;

-- UPDATE
-- change the status of a pokemon if it got caught by a trainer e.g. ID = 1
UPDATE Pokemon
SET TrainerID = 1, GymName = NULL
WHERE PokemonID = 7;

-- DELETE
-- remove a trainer who deleted their account
DELETE FROM Trainer
WHERE TrainerID = 11;

-- Trigger
-- used for checking the maximum amount of pokemons a trainer can have (5)
DELIMITER $$
CREATE TRIGGER PokemonLimit BEFORE INSERT ON Pokemon

FOR EACH ROW 
BEGIN
        DECLARE pokemonCount INT;

        SELECT COUNT(*)
        INTO pokemonCount
        FROM Pokemon 
        WHERE TrainerID = NEW.TrainerID;

        IF pokemonCount >= 5 THEN 
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'maximum number of Pokemon exceeded';
        END IF;
END; $$
DELIMITER ;


-- Function
-- used to return the strongest pokemon of a trainer as pokemonID
DELIMITER $$
CREATE FUNCTION getStrongestPokemon (trainerName VARCHAR(50)) 
RETURNS INT
BEGIN
        DECLARE bestPokemon INT;

        SELECT P.PokemonID
        INTO  bestPokemon
        FROM Pokemon AS P 
        JOIN Trainer AS T ON P.TrainerID = T.TrainerID
        WHERE T.TrainerName = TrainerName
        ORDER BY P.Level DESC
        LIMIT 1;

        RETURN bestPokemon;
END $$
DELIMITER ;

-- PROCEDURE:
-- used to add pokemon and make sure that it is only owned by one unit: trainer or gym
-- has an exact same copy for on update

DELIMITER $$

CREATE TRIGGER unique_ownership
BEFORE INSERT OR Pokemon
FOR EACH ROW
BEGIN
    IF (NEW.TrainerID IS NOT NULL AND NEW.GymName IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Either TrainerID or GymName must be non-null, but not both.';
    END IF;
END$$

DELIMITER ;



-- PROCEDURE
-- used to add a new trainer (not sure if this one is right)
-- add some error checking in there to make it more valid if we still want to make
-- make the trainerName unique: do error check on that
DELIMITER $$
CREATE PROCEDURE addTrainer (
    IN newTrainerName VARCHAR(50),
    IN newTrainerLocation VARCHAR(50)
)
BEGIN
    -- check if the trainer name already exist
    
    IF newTrainerName IN 
      (
        SELECT trainerName
        FROM Trainer
      ) 
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Trainer Name already exist.';
    ELSE
        INSERT INTO Trainer (TrainerName, Location) VALUES (newTrainerName, newTrainerLocation);
    END IF;
END $$
DELIMITER ;



