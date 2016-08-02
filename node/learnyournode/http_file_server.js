var http = require('http');
var fs = require('fs');
var port = Number(process.argv[2]);
var file_name = process.argv[3];

var server = http.createServer(function (req,response) {
    fs.createReadStream(file_name).pipe(response);
}).listen(port);
