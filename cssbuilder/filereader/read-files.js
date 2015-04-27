var fs=require("fs");

var imageName = "image",
urlsToDownload = "{",
uniqueUrlsInCss = [],
i = 0;



//var jquery = fs.readFileSync(__dirname + '/jquery.min.js').toString();

var arguments = process.argv.splice(2),
targetCssFile = arguments[0];

String.prototype.trim=function(){return this.replace(/^\s+|\s+$/g, '');};

function readLines(input, func) {
	  var remaining = '';

	  input.on('data', function(data) {
	    remaining += data;
	    var index = remaining.indexOf('\n');
	    while (index > -1) {
	      var line = remaining.substring(0, index);
	      remaining = remaining.substring(index + 1);
	      func(line);
	      index = remaining.indexOf('\n');
	    }
	  });

	  input.on('end', function() {
	    if (remaining.length > 0) {
	      func(remaining);
	    }

	    fs.open(__dirname + "/urls.json", "r+", 0644, function(err, file_handle) {
			if (!err) {
				urlsToDownload = urlsToDownload.substring(0, urlsToDownload.length - 2);
			    fs.write(file_handle, urlsToDownload + "}", null, 'ascii', function(err, written) {
				    if (!err) {
				            // all worked
				            console.log("Result file created");
				    } else {
				            // writing error occurred
				            console.log("ERROR file created", err);
				    }
				});
			} else {
			   console.log("ERROR file open " + __dirname, err);
			}
		});
	  });

	  input.on('error', function(error) {
	    console.log('Error! :' + error);
	  });
	}

	function func(data) {
	    var myRe = /url\((.*?)\)/;
	    var myArray = myRe.exec(data);

	  	if(myArray) {
	  		var url = myArray[0].replace(/^url\(["']?/, '').replace(/["']?\)$/, '');

	  		url = url.replace("../", "");

	  		if(!inArray(uniqueUrlsInCss, url)){
	  			urlsToDownload += '"' + imageName + i + '" : "' + url + '",' + '\n';
	  			i++;
	  			uniqueUrlsInCss.push(url);
	  		}			
	  	}

	}

	var input = fs.createReadStream(__dirname + '/../' + targetCssFile);
	readLines(input, func);


	function inArray(array, name) {
	    for(var i=0; i<array.length; i++) {
	        if(array[i] === name) {
	            return true;
	        }
	    }
	    return false;
	}