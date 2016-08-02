'use strict';

var connect        = require('connect');
var crypto         = require('crypto');
var path           = require('path');
var sanitizer      = require('validator').sanitize;
var socketio       = require('socket.io');
var tail           = require('./lib/tail');
var connectBuilder = require('./lib/connect_builder');
var program        = require('./lib/options_parser');
var serverBuilder  = require('./lib/server_builder');

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
    .port(program.port)
    .host(program.host)
    .build();

/**
 * socket.io setup
 */
var io = socketio.listen(server, {log: false});


var tailer = tail(program.args, {buffer: program.number});

var filesSocket = io.of('/' + filesNamespace).on('connection', function (socket) {
    socket.emit('options:lines', program.lines);

    tailer.getBuffer().forEach(function (line) {
        socket.emit('line', line);
    });
});


tailer.on('line', function (line) {
    filesSocket.emit('line', sanitizer(line).xss());
});


var cleanExit = function () { process.exit(); };
process.on('SIGINT', cleanExit);
process.on('SIGTERM', cleanExit);

