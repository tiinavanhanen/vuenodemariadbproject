CREATE DATABASE seriesdb;
USE seriesdb;

CREATE TABLE genre (
	genre_id INT NOT NULL AUTO_INCREMENT,
	genre_name VARCHAR(50) NOT NULL,
	PRIMARY KEY ( genre_id )
	);

--all genres, this table won't change
INSERT INTO genre (genre_name) VALUES ('action & adventure'), ('animation'), ('comedy'), ('crime'), ('documentary'),
 ('drama'), ('family'), ('fantasy'), ('history'), ('horror'), ('music'), ('mystery'), ('romance'), ('science fiction'), ('thriller'),
 ('war'), ('soap'), ('talk'), ('western'), ('war & politics'), ('reality'), ('sci-fi & fantasy'), ('news'), ('kids'), ('action'), ('adventure'), ('war');

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

--adding series
INSERT INTO all_series(series_name, genre1, genre2, genre3) VALUE ('sherlok', (SELECT genre_id FROM genre WHERE genre_name='crime'),
(SELECT genre_id FROM genre WHERE genre_name = 'drama'), (SELECT genre_id FROM genre WHERE genre_name='mystery'));

INSERT INTO all_series(series_name, genre1, genre2, genre3) VALUE ('ncis', (SELECT genre_id FROM genre WHERE genre_name='action & adventure'),
(SELECT genre_id FROM genre WHERE genre_name = 'drama'), (SELECT genre_id FROM genre WHERE genre_name='crime'));

--user's personal table
CREATE TABLE testuser (
	series_id INT NOT NULL,
	season INT NOT NULL DEFAULT '1',
	episode INT NOT NULL DEFAULT '1',
	FOREIGN KEY (series_id) REFERENCES all_series(series_id)
	);

--all users and passwords
CREATE TABLE USERS (
	user_id INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(16) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(32) NOT NULL,
	PRIMARY KEY (user_id)
	);

--comments, one table for all series
CREATE TABLE comments(
    series_id INT NOT NULL,
	comment TEXT NOT NULL,
	user_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (series_id) REFERENCES all_series(series_id)
);

--adding a user
INSERT INTO USERS (username, email, password) VALUES (('testuser'), ('testuser@test.test'), ('test'));
INSERT INTO USERS (username, email, password) VALUES (('testuser2'), ('testuser2@test.test'), ('test2'));
INSERT INTO USERS (username, email, password) VALUES (('testuser3'), ('testuser3@test.test'), ('test3'));

--adding series into the user's personal table
INSERT INTO testuser (series_id, episode) VALUES ((SELECT series_id FROM all_series WHERE series_name='sherlok'), ('2'));

--displaying all series from a user's table. mode: series name, season, episode
SELECT series_name, season, episode FROM all_series, testuser  WHERE all_series.series_id=(SELECT series_id FROM testuser);

--adding comments
INSERT INTO comments (series_id, comment, user_id) VALUES
((SELECT series_id FROM all_series WHERE series_name='sherlok'),('Worth watching'), (SELECT user_id FROM users WHERE username='testuser'));

INSERT INTO comments (series_id, comment, user_id) VALUES
((SELECT series_id FROM all_series WHERE series_name='ncis'),('Too many seasons already!'), (SELECT user_id FROM users WHERE username='testuser'));

INSERT INTO comments (series_id, comment, user_id) VALUES
((SELECT series_id FROM all_series WHERE series_name='ncis'),('Dont remember already where it all started from'),
(SELECT user_id FROM users WHERE username='testuser2'));

--selecting all comments for one show
SELECT comment, user_id FROM comments WHERE series_id=(SELECT series_id FROM all_series WHERE series_name='ncis');

--selecting one user's comments for all shows
SELECT series_name, comment FROM all_series, comments  WHERE user_id=(SELECT user_id FROM users WHERE username='testuser')
 AND series_name=(SELECT series_name FROM all_series WHERE series_id= comments.series_id);