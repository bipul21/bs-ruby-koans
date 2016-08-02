var http = require('http');
var url = require('url');


function getUnixTime(strtime) {
    return {
        unixtime: getTimestamp(strtime)
    };
}

function getTimestamp(strtime) {
    return Date.parse(strtime);
}

function getTimeResultObject(strtime) {
    var date = new Date(getTimestamp(strtime));

    return {
        hour: date.getHours(),
        minute: date.getMinutes(),
        second: date.getSeconds()
    };
}

http.createServer(function (req, res) {
    var urlObj = url.parse(req.url, true);

    var pathname = urlObj.pathname;
    var strtime = urlObj.query.iso;
    var result = null;

    if (pathname == '/api/unixtime') {
        result = getUnixTime(strtime);
    } else if (pathname == '/api/parsetime') {
        result = getTimeResultObject(strtime);
    }
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(result));

}).listen(Number(process.argv[2]));

