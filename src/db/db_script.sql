CREATE DATABASE seriesdb;
USE seriesdb;

CREATE TABLE genre (
	genre_id INT NOT NULL AUTO_INCREMENT,
	genre_name VARCHAR(50) NOT NULL,
	PRIMARY KEY ( genre_id )
	);
	
CREATE TABLE all_series (
	series_id INT NOT NULL AUTO_INCREMENT,
	series_name VARCHAR(50) NOT NULL,
	genre1 INT NOT NULL,
	genre2 INT,
	genre3 INT,
	genre4 INT,
	genre5 INT,
	score FLOAT,
	votes INT,
	PRIMARY KEY (series_id),
	FOREIGN KEY (genre1) REFERENCES genre(genre_id),
	FOREIGN KEY (genre2) REFERENCES genre(genre_id),
	FOREIGN KEY (genre3) REFERENCES genre(genre_id),
	FOREIGN KEY (genre4) REFERENCES genre(genre_id),
	FOREIGN KEY (genre5) REFERENCES genre(genre_id)
	);
	
INSERT INTO genre (genre_name) VALUES ('action & adventure'), ('animation'), ('comedy'), ('crime'), ('documentary'),
 ('drama'), ('family'), ('fantasy'), ('history'), ('horror'), ('music'), ('mystery'), ('romance'), ('science fiction'), ('thriller'),
 ('war'), ('soap'), ('talk'), ('western'), ('war & politics'), ('reality'), ('sci-fi & fantasy'), ('news'), ('kids'), ('action'), ('adventure'), ('war');
 
INSERT INTO all_series(series_name, genre1, genre2, genre3) VALUE ('sherlok', (SELECT genre_id FROM genre WHERE genre_name='crime'), 
(SELECT genre_id FROM genre WHERE genre_name = 'drama'), (SELECT genre_id FROM genre WHERE genre_name='mystery'));

CREATE TABLE testuser (
	series_id INT NOT NULL,
	season INT NOT NULL DEFAULT '1',
	episode INT NOT NULL DEFAULT '1',
	FOREIGN KEY (series_id) REFERENCES all_series(series_id)
	);
	
INSERT INTO testuser (series_id, episode) VALUES ((SELECT series_id FROM all_series WHERE series_name='sherlok'), ('2'));

CREATE TABLE USERS (
	user_id INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(16) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(32) NOT NULL,
	PRIMARY KEY (user_id)
	);

INSERT INTO USERS (username, email, password) VALUES (('testuser'), ('testuser@test.test'), ('test'));

CREATE TABLE sherlok(
	comment TEXT NOT NULL,
	user_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO sherlok (comment, user_id) VALUES (('Worth watching'), (SELECT user_id FROM users WHERE username='testuser'));

SELECT series_name, season, episode FROM all_series, testuser  WHERE all_series.series_id=(SELECT series_id FROM testuser); 