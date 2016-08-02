var http = require('http');
var fs = require('fs');
var map = require("through2-map");
var port = Number(process.argv[2]);

var server = http.createServer(function (req,response) {
    if (req.method === 'POST') {
        response.writeHead(200, {'Content-Type': 'text/plain'});
        req.pipe(map(function (chunk) {
            return chunk.toString().toUpperCase();
        })).pipe(response);
    }
}).listen(port);
