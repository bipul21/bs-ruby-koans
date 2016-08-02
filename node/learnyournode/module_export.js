var filemodule = require("./list_file_module.js");

var dir = process.argv[2];
var ext = process.argv[3];

filemodule(dir,ext,function(err,files){
    if(err){
        throw new Error("Error");
    }
    else{
        for(var i = 0; i < files.length; i++){
            console.log(files[i]);
        }
    };
});