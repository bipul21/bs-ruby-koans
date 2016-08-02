var fs = require('fs');
var file_name = process.argv[2];

function file_callback(error,data) {
    console.log(data.toString().split("\n").length - 1);
}
fs.readFile(file_name,file_callback);

