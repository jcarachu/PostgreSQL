--create new country tabel
CREATE TABLE countries (
	country_code char(2) PRIMARY KEY,
	country_name text UNIQUE
);

-- insert values into counties
INSERT INTO countries (country_code, country_name)
VALUES ('us','United States'), ('mx','Mexico'), ('au','Australia'), ('gb', 'United Kingdom'), ('de','Germany'), ('ll','Loompaland');

-- select all
SELECT *
FROM countries;

-- delete country code
DELETE FROM countries
WHERE country_code = 'll';

-- select all
SELECT *
FROM countries;

-- create new table
CREATE TABLE cities (
	name text NOT NULL,
	postal_code varchar(9) CHECK (postal_code <> ''),
	country_code char(2) REFERENCES countries NOT NULL,
	PRIMARY KEY (country_code, postal_code)
);

-- add invalid item
INSERT INTO cities
VALUES ('Toronto', 'M4C1B5', 'ca');

-- add item
INSERT INTO cities
VALUES ('Portland', '87200', 'us');

-- update item
UPDATE cities
SET postal_code = '97205'
WHERE name = 'Portland';

-- list all cities whose country code matches the city
SELECT cities.*, country_name
FROM cities INNER JOIN countries
ON cities.country_code = countries.country_code;

-- create new venues table
CREATE TABLE venues (
	venue_id SERIAL PRIMARY KEY,
	name varchar(225),
	street_address text,
	type char(7) CHECK (type in ('public','private')) DEFAULT 'public',
	postal_code varchar(9),
	country_code char(2),
	FOREIGN KEY (country_code, postal_code)
	REFERENCES cities (country_code, postal_code) MATCH FULL
);

-- insert values into venues table
INSERT INTO venues (name, postal_code, country_code)
VALUES ('Crystal Ballroom', '97205', 'us');

-- list venues's id,name, and city name if postal and country code match
SELECT v.venue_id, v.name, c.name
FROM venues v INNER JOIN cities c
ON v.postal_code = c.postal_code AND v.country_code = c.country_code;

-- insert values into venues table
INSERT INTO venues (name, postal_code, country_code)
VALUES ('Voodoo Donuts', '97205', 'us') RETURNING venue_id;

-- create new events table
CREATE TABLE events (
	event_id SERIAL PRIMARY KEY,
	title varchar(255),
	starts timestamp,
	ends timestamp,
	venue_id int,
	FOREIGN KEY (venue_id)
	REFERENCES venues (venue_id)
);

-- insert values into events 
INSERT INTO events (title, starts, ends, venue_id)
VALUES	
		('LARP Club', '2012-02-15 17:30:00', '2012-02-15 19:30:00',2),
		('April Fools Day', '2012-04-01 00:00:00', '2012-04-01 23:59:00', NULL),
		('Christmas Day', '2012-12-25 00:00:00', '2012-12-25 23:59:00', NULL);


-- list all events's tile and venue name is venue id matches
SELECT e.title, v.name
FROM events e JOIN venues v
ON e.venue_id = v.venue_id;

-- list all event's title and also venues's name if has matching venue_id
SELECT e.title, v.name
FROM events e LEFT JOIN venues v
ON e.venue_id = v.venue_id;

-- index using b tree
CREATE INDEX events_starts
ON events USING btree (starts);
