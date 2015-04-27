#!/usr/bin/env node

console.log("start imagesdownload.js");

var casper = require('casper').create(),
    fs = require('fs'),
    options = casper.cli.options;

var data, wsurl = 'http://localhost:' + options.port + '/urls.json';

casper.start('http://localhost:' + options.port, function() {
    data = this.evaluate(function(wsurl) {
        return JSON.parse(__utils__.sendAJAX(wsurl, 'GET', null, false));
    }, {wsurl: wsurl});
});

casper.then(function(){
    casper.start(options.baseurl, function() {
        var path = options.baseurl + '/' + options.imagesRemoteRelativePath + '/';
        for (var key in data) {
            var url = path + data[key];
            this.download(url, options.destImageDir + '/' + data[key]);
        }   
    });
});

casper.run(function() {
    this.echo('Done.').exit();
});