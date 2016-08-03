'use strict';

var program = require('commander');

program
    .version(require('../package.json').version)
    .usage('[options] [file ...]')

module.exports = program;
