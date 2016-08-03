'use strict';

var connect        = require('connect');
var crypto         = require('crypto');
var path           = require('path');
var sanitizer      = require('validator').sanitize;
var socketio       = require('socket.io');
var Tail           = require('tail').Tail;
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
    .port(8000)
    .host(program.host)
    .build();

/**
 * socket.io setup
 */
var io = socketio.listen(server, {log: false});


var tailer = new Tail(files);

var filesSocket = io.of('/' + filesNamespace).on('connection', function (socket) {
    console.log("File Socket Connected !!");
});


tailer.on('line', function (line) {
    filesSocket.emit('line', sanitizer(line).xss());
});


var cleanExit = function () { process.exit(); };
process.on('SIGINT', cleanExit);
process.on('SIGTERM', cleanExit);