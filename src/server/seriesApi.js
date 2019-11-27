const express = require('express');
const router = express.Router();
const mysql = require('mysql');
const config = require('../db/db_config.js');
const db = config.database;
const url = require('url');
const theMovieDb = require('../themoviedb/themoviedb');
const con = mysql.createConnection({user: db.user, password: db.password, host: db.host, database: db.database});
con.connect();

router.get("/all_shows", function (req, res) {
    /* eslint-disable no-console */
    console.log("get all series ");

    var sql = "SELECT series_name, votes, (score/votes) AS rating FROM all_series;";

    con.query(sql,  function (err, result) {
        if (err)
            throw (err);
        else{
            console.log(result);

            res.send(JSON.stringify(result));
            /* eslint-enable no-console */
        }
    });
});

router.get("/comments", function (req, res) {
    /* eslint-disable no-console */
    var q = url.parse(req.url, true).query;
    var name = q.showname;
    var sql = "SELECT comment, username FROM comments, users WHERE series_id=(SELECT series_id FROM all_series WHERE series_name=?) AND username=(SELECT username from users WHERE user_id=comments.user_id);";

    con.query(sql, [name],function (err, result) {
        if (err)
            throw (err);
        else{
            console.log(result);

            res.send(JSON.stringify(result));
        }
    });
});

router.get("/addcomment", function (req, res) {
    /* eslint-disable no-console */
    var q = url.parse(req.url, true).query;
    var name = q.showname;
    console.log("comments showname" + name);
    var comment = q.comment;
    var sql = "INSERT INTO comments (series_id, comment, user_id) VALUES\n" +
        "((SELECT series_id FROM all_series WHERE series_name=?),(?),\n" +
        "(SELECT user_id FROM users WHERE username='testuser2'));";
    con.query(sql, [name, comment],function (err, result) {
        if (err)
            throw (err);
        else{
            console.log(result);

            res.send(JSON.stringify(result));
        }
    });
});

router.get("/recommend", function (req, res) {
    /* eslint-disable no-console */
    var q = url.parse(req.url, true).query;
    var username = q.username;
    //console.log(username);
    var genre = q.genre;
    var sql = "SELECT series_name, votes, (score/votes) AS rating from all_series, ?? WHERE (score/votes>2) AND" +
        "(genre2=? " +
        "OR genre1=?" +
        "OR genre3=?" +
        "OR genre4=?" +
        "OR genre5=?) AND" +
        "(all_series.series_id !=(SELECT series_id FROM ??));";
    con.query(sql, [username, genre, genre, genre, genre, genre, username],function (err, result) {
        if (err)
            throw (err);
        else{
            console.log(result);

            res.send(JSON.stringify(result));
        }
    });
});

router.get("/show", function (req,res){
    console.log("get show details");
    var q = url.parse(req.url, true).query;
    var showname = q.series_name;
    //var sql ="SELECT series_name, genre1, genre2, genre3, votes, (score/votes) AS rating FROM all_series WHERE series_name=?;"
   // var sql = "SELECT series_name, genre_name, genre_name, genre_name, votes, (score/votes) AS rating FROM all_series, genre WHERE series_name=? AND (genre_id =(SELECT genre1 from all_series WHERE series_name=?) or (genre_id =(SELECT genre2 from all_series WHERE series_name=?) ) or (genre_id =(SELECT genre3 from all_series WHERE series_name=?) ));";
    var sql="SELECT s.series_name, g1.genre_name as genre_name1, g2.genre_name as genre_name2, g3.genre_name as genre_name3, s.votes, (s.score/s.votes) AS rating FROM all_series AS s LEFT JOIN genre AS g1 ON s.genre1=g1.genre_id LEFT JOIN genre AS g2 ON s.genre2=g2.genre_id LEFT JOIN genre AS g3 ON s.genre3=g3.genre_id LEFT JOIN genre AS g4 ON s.genre4=g4.genre_id WHERE s.series_name=?;" ;
    con.query(sql, [showname], function (err, result) {
        if (err)
            throw (err);
        else {
            console.log(result);

            res.send(JSON.stringify(result));
        }
    });

});

router.get("/addseries", function (req, res) {
    console.log("add series");
    var q = url.parse(req.url, true).query;
    var name = q.showname;
    var user = q.username;
    var genres = getGenreIds(name, function(response) {
        return response;
    });
    console.log("genres ulkona: " + genres);
    var seriesID = getSeriesId(name, genres, function (response) {
        return response;
    });
    console.log("series id ulkona: " + seriesID);

    /*function checkSeries(user, name) {
        var sql = "SELECT series_id FROM ?? WHERE series_id=(SELECT series_id FROM all_series WHERE series_name=?);";
        con.query(sql, [user, name], function (err ,result) {
            if (result) {
                if (result.length > 0) {
                    console.log("sarja on jo taulussa");
                    res.end("on jo");
                } else {
                    console.log("sarjaa ei löytynyt taulusta");
                    res.end("ei ole");
                }
            } else {
                throw err;
            }
        });
    }
     */

    function getSeriesId(name, genres, callback) {
        var seriesID = -1;
        var sql = "SELECT series_id FROM all_series WHERE series_name=?";
        con.query(sql, [name], function (err, result) {
            if (result) {
                if (result.length > 0) {
                    seriesID = result[0].series_id;
                    console.log("found series id: " + seriesID);
                    res.end("series id löydetty");
                } else {
                    var sql2 = "";
                    if (genres.length === 1) {
                        sql2 = "INSERT INTO all_series (series_name, genre1) VALUES (?,?)";
                        con.query(sql2, [name, genres[0]], function(err, result) {
                            if (err) throw err;
                            seriesID = result.insertId;
                            console.log("1 genre series id: " + seriesID);
                            callback(seriesID);
                        });
                    } else if (genres.length === 2) {
                        sql2 = "INSERT INTO all_series (series_name, genre1, genre2) VALUES (?,?,?)";
                        con.query(sql2, [name, genres[0], genres[1]], function(err, result) {
                            if (err) throw err;
                            seriesID = result.insertId;
                            console.log("2 genre series id: " + seriesID);
                            callback(seriesID);
                        });
                    } else if (genres.length === 3) {
                        sql2 = "INSERT INTO all_series (series_name, genre1, genre2, genre3) VALUES (?,?,?,?)";
                        con.query(sql2, [name, genres[0], genres[1], genres[2]], function(err, result) {
                            if (err) throw err;
                            seriesID = result.insertId;
                            console.log("3 genre series id: " + seriesID);
                            callback(seriesID);
                        });
                    } else if (genres.length === 4) {
                        sql2 = "INSERT INTO all_series (series_name, genre1, genre2, genre3, genre4) VALUES (?,?,?,?,?)";
                        con.query(sql2, [name, genres[0], genres[1], genres[2], genres[3]], function(err, result) {
                            if (err) throw err;
                            seriesID = result.insertId;
                            console.log("4 genre series id: " + seriesID);
                            res.end("series id luotu 4 genre");
                            callback(seriesID);
                        });
                    } else if (genres.length === 5) {
                        sql2 = "INSERT INTO all_series (series_name, genre1, genre2, genre3, genre4, genre5) VALUES (?,?,?,?,?,?)";
                        con.query(sql2, [name, genres[0], genres[1], genres[2], genres[3], genres[4]], function(err, result) {
                            if (err) throw err;
                            seriesID = result.insertId;
                            console.log("5 genre series id: " + seriesID);
                            res.end("series id luotu 5 genre");
                            callback(seriesID);
                        });
                    }
                }
            } else {
                throw err;
            }
        });
    }



    function getGenreIds(name, callback) {
        theMovieDb.search.getTv({"query": name}, showSeries, showError);
        function showSeries(data) {
            console.log(data);
            data = JSON.parse(data);
            var genreIds = data.results[0].genre_ids;
            console.log("genreIds sisällä: " + genreIds);
            callback(genreIds);
        }
        function showError() {
            console.log("Tapahtui virhe");
        }
    }


});

module.exports = router;