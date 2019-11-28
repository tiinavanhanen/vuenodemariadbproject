CREATE DATABASE seriesdb;
USE seriesdb;

CREATE TABLE genre (
	genre_id INT NOT NULL,
	genre_name VARCHAR(50) NOT NULL,
	PRIMARY KEY ( genre_id )
	);

--all genres, this table won't change
INSERT INTO genre (genre_id, genre_name) VALUES ('10759','action & adventure'), ('16', 'animation'), ( '35','comedy'), ('80','crime'), ('99', 'documentary'),
 ('18','drama'), ('10751','family'), ('10762', 'kids'), ('9648', 'mystery'), ('10766','soap'), ('10767', 'talk'), ('37','western'), ('10768','war & politics'), ('10764','reality'), ('10765','sci-fi & fantasy'), ('10763','news');

CREATE TABLE all_series (
	series_id INT NOT NULL AUTO_INCREMENT,
	series_name VARCHAR(50) NOT NULL,
	genre1 INT NOT NULL,
	genre2 INT,
	genre3 INT,
	genre4 INT,
	genre5 INT,
	score FLOAT DEFAULT '0',
	votes INT DEFAULT '0',
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

INSERT INTO all_series(series_name, genre1, genre2, genre3) VALUE ('supernatural', (SELECT genre_id FROM genre WHERE genre_name='sci-fi & fantasy'),
(SELECT genre_id FROM genre WHERE genre_name = 'drama'), (SELECT genre_id FROM genre WHERE genre_name='mystery'));


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

--adding a new user
INSERT INTO USERS (username, email, password) VALUES (('testuser'), ('testuser@test.test'), ('test'));
INSERT INTO USERS (username, email, password) VALUES (('testuser2'), ('testuser2@test.test'), ('test2'));
INSERT INTO USERS (username, email, password) VALUES (('testuser3'), ('testuser3@test.test'), ('test3'));

--adding series into the user's personal table
INSERT INTO testuser (series_id, episode) VALUES ((SELECT series_id FROM all_series WHERE series_name='sherlok'), ('2'));

--displaying all series from a user's table. mode: series name, season, episode
SELECT series_name, season, episode FROM all_series, testuser  WHERE all_series.series_id=(SELECT series_id FROM testuser);

--updating show's data in user's table
UPDATE testuser SET episode=3 WHERE series_id=(SELECT series_id FROM all_series WHERE series_name='sherlok');

--adding comments
INSERT INTO comments (series_id, comment, user_id) VALUES
((SELECT series_id FROM all_series WHERE series_name='sherlok'),('Worth watching'), (SELECT user_id FROM users WHERE username='testuser'));

INSERT INTO comments (series_id, comment, user_id) VALUES
((SELECT series_id FROM all_series WHERE series_name='ncis'),('Too many seasons already!'), (SELECT user_id FROM users WHERE username='testuser'));

INSERT INTO comments (series_id, comment, user_id) VALUES
((SELECT series_id FROM all_series WHERE series_name='ncis'),('Dont remember already where it all started from'),
(SELECT user_id FROM users WHERE username='testuser2'));

--selecting all comments for one show, display user's id
SELECT comment, user_id FROM comments WHERE series_id=(SELECT series_id FROM all_series WHERE series_name='ncis');

--selecting all comments for one show, display user's name
SELECT comment, username FROM comments, users
WHERE series_id=(SELECT series_id FROM all_series WHERE series_name='ncis')
AND username=(SELECT username from users WHERE user_id=comments.user_id);

--selecting one user's comments for all shows
SELECT series_name, comment FROM all_series, comments  WHERE user_id=(SELECT user_id FROM users WHERE username='testuser')
 AND series_name=(SELECT series_name FROM all_series WHERE series_id= comments.series_id);

--updating score and votes
UPDATE all_series SET score=score+5, votes=votes+1 WHERE series_name='ncis';

--showing name, votes and rating of one show
SELECT series_name, votes, (score/votes) AS rating FROM all_series WHERE series_name='ncis';

----showing name, votes and rating of all shows
SELECT series_name, votes, (score/votes) AS rating FROM all_series;

--showing shows with a particular rating
SELECT series_name, votes, (score/votes) AS rating from all_series WHERE (score/votes) >3;

--showing shows with a particular rating and genre
SELECT series_name, votes, (score/votes) AS rating from all_series  WHERE
(score/votes>3) AND
(genre2=(SELECT genre_id FROM genre WHERE genre_name='crime')
OR genre1=(SELECT genre_id FROM genre WHERE genre_name='crime')
OR genre3=(SELECT genre_id FROM genre WHERE genre_name='crime')
OR genre4=(SELECT genre_id FROM genre WHERE genre_name='crime')
OR genre5=(SELECT genre_id FROM genre WHERE genre_name='crime'));

--showing shows with a particular rating and genre that are not in a user's own table
SELECT series_name, votes, (score/votes) AS rating from all_series, testuser  WHERE
(score/votes>2) AND
(genre2=(SELECT genre_id FROM genre WHERE genre_name='drama')
OR genre1=(SELECT genre_id FROM genre WHERE genre_name='drama')
OR genre3=(SELECT genre_id FROM genre WHERE genre_name='drama')
OR genre4=(SELECT genre_id FROM genre WHERE genre_name='drama')
OR genre5=(SELECT genre_id FROM genre WHERE genre_name='drama')) AND
(all_series.series_id !=(SELECT series_id FROM testuser));

--showing name, genres, votes and rating for all shows
SELECT s.series_name, g1.genre_name AS genre_name1, g2.genre_name AS genre_name2, g3.genre_name AS genre_name3, s.votes, (s.score/s.votes) AS rating FROM all_series AS s
LEFT JOIN genre AS g1 ON s.genre1=g1.genre_id
LEFT JOIN genre AS g2 ON s.genre2=g2.genre_id
LEFT JOIN genre AS g3 ON s.genre3=g3.genre_id
LEFT JOIN genre AS g4 ON s.genre4=g4.genre_id;

--showing name, genres, votes and rating for one show
SELECT s.series_name, g1.genre_name AS genre_name1, g2.genre_name AS genre_name2, g3.genre_name AS genre_name3, s.votes, (s.score/s.votes) AS rating
FROM all_series AS s
LEFT JOIN genre AS g1 ON s.genre1=g1.genre_id
LEFT JOIN genre AS g2 ON s.genre2=g2.genre_id
LEFT JOIN genre AS g3 ON s.genre3=g3.genre_id
LEFT JOIN genre AS g4 ON s.genre4=g4.genre_id
WHERE s.series_name="ncis";

--checking if show is already in user's table
SELECT series_id FROM testuser WHERE series_id=(SELECT series_id FROM all_series WHERE series_name="ncis");