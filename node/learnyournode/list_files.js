var fs = require('fs');

function filter_filenames(file_name, file_extension){
    var file_split = file_name.split(".");
    return !!(file_split.length > 1 && file_split[1] == file_extension);

}
function file_callback(error,file_list) {
    var new_file_list = file_list.filter(filter_filenames, file_extensions);
    for(var i=0 ; i < new_file_list.length; i++){
        var file_name = new_file_list[i];
        console.log(file_name)
    }
}

function read_filter_files(dir_name, file_extension, callback){
    fs.readdir(dir_name,callback);
}

read_filter_files(dir_name,file_extensions, file_callback);

var dir_name = process.argv[2];
var file_extensions = process.argv[3];
module.exports = read_filter_files;


