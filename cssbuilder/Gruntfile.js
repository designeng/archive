/*
 * grunt-autoprefixer
 * 
 *
 * Copyright (c) 2013 Dmitry Nikitenko
 * Licensed under the MIT license.
 */

'use strict';

var dirForBuildedCss = 'builded',
    localServerPort = 8902,
    destCss = 'multiple.css',
    buildedCssPath = dirForBuildedCss + '/' + destCss;

//casper script settings
var baseUrl = 'https://base-url.ru', //with slash in the end
    imagesRemoteRelativePath = "media", //with slash in the end

    destImageDir = "images";


module.exports = function (grunt) {

    // Project configuration.
    grunt.initConfig({
        // Before generating any new files, remove any previously-created files.
        clean: {
                tests: [dirForBuildedCss, destImageDir]
        },


        csscreate: {
            multiple: {
                src: 'csstobuild/*.css',
                dest: buildedCssPath
            }

        },

        exec: {
          filereader: {
            command: 'node filereader/read-files.js ' + buildedCssPath,
            stdout: true
          },
          imagesdownload: {
            command: 'casperjs filereader/casperjs/bin/imagesdownload.js --port=' + localServerPort + ' --baseurl=' + baseUrl + ' --imagesRemoteRelativePath=' + imagesRemoteRelativePath + ' --destImageDir=' + destImageDir,
            stdout: true
          }
        },

        connect: {
            jsonserver:{
                options: {
                  port: localServerPort,
                  base: 'filereader'
                }
            }
        },

        regarde: {    
          js: {
            files: ['filereader/*.js'],
            tasks: []
          }
        }

    });

    // Actually load this plugin's task(s).
    grunt.loadTasks('tasks');

    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks('grunt-regarde');
    grunt.loadNpmTasks('grunt-contrib-connect');

    grunt.registerTask('buildcss', ['clean', 'csscreate']);

    grunt.registerTask('default', ['buildcss', 'exec:filereader', 'connect', 'clean', 'exec:imagesdownload']);

};
