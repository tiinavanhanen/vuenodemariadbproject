const express = require('express');
const router = express.Router();
const mysql = require('mysql');
const config = require('../db/db_config.js');
const db = config.database;
//const url = require('url');
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

module.exports = router;