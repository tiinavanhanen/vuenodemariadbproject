const express = require('express');
const app = express();
//var url = require('url');
//var mysql = require("mysql");
//const urlencodedParser = require('urlencoded-parser'); // ES5
const bodyParser = require('body-parser');
const cors = require('cors');
const seriesApi = require('../server/seriesApi.js');

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
//app.use(urlencodedParser);

app.use(cors({
    'allowedHeaders': ['Content-Type'],
    'origin': '*',
    'preflightContinue': true
}));

app.use('/api', seriesApi);

var server = app.listen(8080, function () {
    var host = server.address().address;
    var port = server.address().port;
    /* eslint-disable no-console */
    console.log("Example app listening at http://%s:%s", host, port)
    /* eslint-enable no-console */
});

