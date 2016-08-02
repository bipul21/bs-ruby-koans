var fs = require("fs");
var path = require("path");

module.exports = function(dirname,extension,callback){
    var list = [];
    var i = 0;

    fs.readdir(dirname, function(err,files){
        if(err){
            return callback(err);
        }
        else{
            extension = '.' + extension;
            files.forEach(function(fileName){
                if(path.extname(fileName) === extension){
                    list.push(fileName);
                }
            })
        }
        return callback(null,list);
    })
};
