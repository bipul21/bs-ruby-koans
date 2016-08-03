'use strict';

var connect        = require('connect');
var crypto         = require('crypto');
var path           = require('path');
var sanitizer      = require('validator').sanitize;
var socketio       = require('socket.io');
var fs = require('fs');
var http = require('http');
var CBuffer = require('CBuffer');
var cbuffer = new CBuffer(10);
var files = process.argv[2];
var filesNamespace = crypto.createHash('md5').update(files).digest('hex');


function index(req, res) {
    fs.readFile(__dirname + '/lib/web/index.html', function (err, data) {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end(data.toString('utf-8')
                .replace(/__NAMESPACE__/g, filesNamespace),
            'utf-8'
        );
    });
}
var filename = files;
var connectBuild = connect().use(connect.static(__dirname + '/lib/web/assets')).use(index);
var server = http.createServer(connectBuild).listen(8000);

if(cbuffer.size == 0){
    var file_content = fs.readFileSync(filename).toString().trim().replace(/^\s+|\s+$/g, "").split("\n");
    file_content.slice(1).slice(-10).forEach(function(line){
        cbuffer.push(line);
    });
}

/**
 * socket.io setup
 */
var io = socketio.listen(server, {log: false});
var filesSocket = io.of('/' + filesNamespace).on('connection', function (socket) {
    cbuffer.toArray().forEach(function (line) {
        socket.emit('line', line);
    });

});

var fileStat = null;
fs.stat(filename, function(err,stats){
    fileStat = stats;
    fs.watch(filename, function (event, f) {
        fs.stat(filename, function(error, changedFileStat){
            fs.open(filename, 'r', function(err, fd) {
                var dataLength = changedFileStat.size - fileStat.size;
                var buffer = Buffer.alloc(dataLength, 0, 'utf-8');
                fs.read(fd, buffer, 0, dataLength, fileStat.size, function (err, bytesRead, data) {
                    data.toString().replace(/^\s+|\s+$/g, "").split("\n").forEach(function (dataLine) {
                        cbuffer.push(data.toString());
                        filesSocket.emit('line', dataLine);
                    });
                });
                fileStat = changedFileStat;
            });
        });
    });
});

var cleanExit = function () { process.exit(); };
process.on('SIGINT', cleanExit);
process.on('SIGTERM', cleanExit);