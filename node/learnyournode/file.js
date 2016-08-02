var fs = require('fs');
var file_name = process.argv[2];
var file_content = fs.readFileSync(file_name);
console.log(file_content.toString().split("\n").length - 1);

