'use strict';

var connect        = require('connect');
var crypto         = require('crypto');
var path           = require('path');
var sanitizer      = require('validator').sanitize;
var socketio       = require('socket.io');
var connectBuilder = require('./lib/connect_builder');
var program        = require('./lib/options_parser');
var serverBuilder  = require('./lib/server_builder');
var fs = require('fs');
var CBuffer = require('CBuffer');

program.parse(process.argv);
if (program.args.length === 0) {
    console.error('Arguments needed, use --help');
    process.exit();
}

var files = program.args.join(' ');
var filesNamespace = crypto.createHash('md5').update(files).digest('hex');


/**
 * HTTP(s) server setup
 */
var appBuilder = connectBuilder();

appBuilder
    .static(__dirname + '/lib/web/assets')
    .index(__dirname + '/lib/web/index.html', files, filesNamespace, program.theme);

var builder = serverBuilder();

var server = builder
    .use(appBuilder.build())
    .port(8000)
    .host(program.host)
    .build();

/**
 * socket.io setup
 */
var io = socketio.listen(server, {log: false});

var cbuffer = new CBuffer(10);

var filesSocket = io.of('/' + filesNamespace).on('connection', function (socket) {
    cbuffer.toArray().forEach(function (line) {
        socket.emit('line', line);
    });

});

var filename = files;
var fileStat = fs.statSync(filename);
fs.watch(filename, function (event, f) {
    var changedFileStat = fs.statSync(filename);
    fs.open(filename, 'r', function(err, fd) {
        var dataLength = changedFileStat.size - fileStat.size;
        var buffer = Buffer.alloc(dataLength, 0, 'utf-8');
        fs.read(fd, buffer, 0, dataLength, fileStat.size, function (err, bytesRead, data) {
            cbuffer.push(sanitizer(data.toString()).xss());
            filesSocket.emit('line', sanitizer(data.toString()).xss());
        });
        fileStat = fs.statSync(filename);
    });
});

var cleanExit = function () { process.exit(); };
process.on('SIGINT', cleanExit);
process.on('SIGTERM', cleanExit);