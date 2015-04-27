###
@Author (c) 2013 Denis Savenok
@Licensed under the MIT license.
###

lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
connectMW = require(require("path").resolve("tasks", "connectMiddleware.js"))
rewriteRulesSnippet = require('grunt-connect-rewrite/lib/utils').rewriteRequest

module.exports = (grunt) ->
    grunt.initConfig
        vars: grunt.file.readJSON("config.json")
        serverHostname: "<%= vars.serverHostname %>"
        connect:
            livereload:
                options:
                    hostname: "<%= serverHostname %>"
                    port: 8877
                    base: "."
                    middleware: (connect, options) ->
                        return [
                            connect.bodyParser()
                            rewriteRulesSnippet
                            lrSnippet
                            connectMW.folderMount(connect, options.base)
                            # connectMW.beforeAll
                            connectMW.redirections
                            connectMW.proxy
                            connectMW.mockProxy
                            connectMW.getStubJSON
                        ]
                rules:
                    "^/$" : "/app/"
                    "^/(?!test).*/$" : "/app/"
                    "^/tests/$" : "/tests/"
            builded:                                                                                                            # task "connect:builded" for browser checking builded application
                options:
                    port: 8903
                    base: "public"
                    middleware: (connect, options) ->
                        [connect.bodyParser(), connectMW.folderMount(connect, options.base), connectMW.redirections, connectMW.proxy, connectMW.mockProxy]
                rules:
                    "^/$" : "/public/"

        configureRewriteRules:
            options:
                rulesProvider: 'connect.livereload.rules'

        livereload:
            port: 35737                                                                                                         # Default livereload listening port. (35729 ?)

        regarde:
            # no need to reload on .js change if we reload on .coffee
            # jsspec:
            #     files: ["tests/**/*.js", "tests/**/**/*.js", "!node_modules/**/*.js"]
            #     tasks: ["livereload"]
            coffee:
                files: ['app/coffee/*.coffee', 'app/coffee/**/*.coffee'],
                tasks: ['livereload']
            coffee_tests:
                files: ['tests/coffee/*.coffee', 'tests/coffee/**/*.coffee'],
                tasks: ['livereload']
            html:
                files: ["app/templates/**/*.html", "app/templates/**/**/*.html", "app/templates/**/**/**/*.html"]
                tasks: ["livereload"]
            css:
                files: ["static/global/less/global.less", "static/**/**.less", "static/**/**/**.less"]
                tasks: ["less", "livereload"]
            config:
                files: ["app/scripts/require.config.js"]
                tasks: ["livereload"]

        coffee:
            each:
                options: {}
                files: [
                    expand: true,
                    cwd: 'app/coffee',
                    src: ['**/*.coffee'],
                    dest: 'app/js/',
                    ext: '.js'
                ]
            tests:
                options: {}
                files: [
                    expand: true,
                    cwd: 'tests/coffee',
                    src: ['**/*.coffee'],
                    dest: 'tests/',
                    ext: '.js'
                ]

        copy:
            allSource:
                files: [
                    expand: true
                    cwd: "app/"
                    src: ["**"]
                    dest: "prebuild/"
                    filter: "isFile"
                ]

        clean:
            appBefore: "prebuild"
            appTemplates: "prebuild/templates"
            appStylesLess: "prebuild/styles/less"
            appCoffee: "prebuild/coffee"
            appAfter: "prebuild"

        strip:
            main:
                src: "prebuild/scripts/**/*.js"
                options:
                    inline: true

        html_minify:
            options: {}
            all:
                files: [
                    expand: true
                    cwd: "app/templates/"
                    src: ["**/*.html"]
                    dest: "prebuild/templates"
                    ext: ".html"
                ]

        requirejs:
            compile:
                options:                                                                                                        # Look at https://github.com/jfparadis/requirejs-handlebars/blob/master/build.js
                    appDir: "prebuild"
                    baseUrl: "js"
                    mainConfigFile: "prebuild/js/requireConfig.js"
                    dir: "public"
                    inlineText: true

                    # stubModules: ['text', 'hbars'],
                    removeCombined: true
                    preserveLicenseComments: true
                    optimize: "none"
                    uglify:
                        toplevel: true
                        ascii_only: true
                        beautify: false
                        max_line_length: 1000
                        defines:                                                                                                # How to pass uglifyjs defined symbols for AST symbol replacement, see "defines" options for ast_mangle in the uglifys docs.
                            DEBUG: ["name", "false"]
                        no_mangle: true                                                                                                                                # Custom value supported by r.js but done differently in uglifyjs directly: Skip the processor.ast_mangle() part of the uglify call (r.js 2.0.5+)

                    modules: [
                            name: "main"
                            include: ["main"]
                            create: true
                        ]

        jasmine:
            src: "app/**/*.js"
            options:
                specs: "jasmine/**/*.js"

        exec:
            jasmine:
                command: "phantomjs test/lib/run-jasmine.js http://localhost:8877/test"
                stdout: true

            # generate documentation with npm docco-next 
            docco:
                command: "node ./tasks/bin/docco -o docs -l ./resources/languages.example.json --title 'Project annotated source' ./app/coffee"
                stdout: true

            # log out current brunch name 
            gitbranch:
                command: "git rev-parse --abbrev-ref HEAD"
                stdout: true

        compress:
            main:
                options:
                    archive: "packer/packer.zip"
                expand: true
                src: ["**/*", "!node_modules/**", "!packer/**"]

        # Dont' remove! below usefull tasks we leverage from time to time
        js2coffee:
            each:
                options: {}
                files:[
                    {
                        expand: true
                        cwd: 'tocoffee'
                        src: ['**/*.js']
                        dest: 'tests-coffee'
                        ext: '.coffee'
                    }
                ]

    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-exec"
    grunt.loadNpmTasks "grunt-regarde"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-livereload"
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-jasmine"                                                                                  # testing tools
    grunt.loadNpmTasks "grunt-strip"                                                                                            # remove console.* statements
    grunt.loadNpmTasks "grunt-html-minify"
    grunt.loadNpmTasks "grunt-contrib-requirejs"
    grunt.loadNpmTasks "grunt-contrib-compress"
    grunt.loadNpmTasks "grunt-connect-rewrite"
    grunt.loadNpmTasks "grunt-growl"
    grunt.loadNpmTasks "grunt-js2coffee"                                                                                          # for use mac-notifications you should run: sudo gem install terminal-notifier

    grunt.registerTask "jasmine", ["jasmine"]
    grunt.registerTask "pack", ["compress"]
    grunt.registerTask "server", ["configureRewriteRules", "livereload-start", "connect:livereload", "regarde"]
    grunt.registerTask "default", ["checkGrunt", "server"]

    grunt.registerTask "coffcomp", ["coffee:each", "server"]
    grunt.registerTask "coffcomptests", ["coffee:tests", "server"]
    
    grunt.registerTask "branch", ["exec:gitbranch"]

    grunt.registerTask "checkGrunt", "Check grunt settings and params", ->
        grunt.log.ok "Grunt-file found"
        grunt.log.writeln "Grunt version: " + grunt.version
        grunt.task.run "contribs"

    grunt.registerTask "contribs", "Check node-modules", ->
        _ = require("underscore")
        path = require("path")
        config = grunt.file.readJSON(path.resolve("package.json"))
        keys = _.keys(config.devDependencies)
        try
            item = ""
            for item of keys
                req = require(keys[item])
            grunt.log.ok "All dependencies installed"
        catch e
            grunt.log.error "Some modules not installed\n"
            grunt.task.run "installModules"

    grunt.registerTask "installModules", "Install node-modules", ->
        done = @async()
        cp = require("child_process")
        npmProc = cp.spawn("npm", ["install"])
        grunt.log.write "Installing modules...\n"
        npmProc.stdout.on "data", (data) ->
            console.log new Buffer(data).toString()
        npmProc.on "exit", ->
            done()

    grunt.registerTask "strip-console-logs", ["strip"]
    grunt.registerTask "prebuild", ["clean:appBefore", "copy:allSource", "strip-console-logs", "clean:appTemplates", "clean:appStylesLess", "clean:appCoffee", "html_minify"]
    grunt.registerTask "build", ["prebuild", "requirejs", "edit-requirejs-config", "clean:appAfter", "clean-public", "connect:builded", "regarde"]
    
    grunt.task.registerTask "edit-requirejs-config", "After build we must to rename some params of requirejs configuration and make some changes in index.html.", ->
        fs = require("fs")
        requirejsGruntConfig = grunt.config.getRaw("requirejs")
        mainConfigFile = requirejsGruntConfig.compile.options.mainConfigFile
        appDir = requirejsGruntConfig.compile.options.appDir
        dir = requirejsGruntConfig.compile.options.dir
        baseUrl = requirejsGruntConfig.compile.options.baseUrl
        dstConfigFile = mainConfigFile.replace(appDir, dir)
        resultContent = ""
        targetParam = "baseUrl"

        content = fs.readFileSync(__dirname + "/" + mainConfigFile, "utf-8").toString().split("\n").forEach((line) ->
            line = targetParam + ":\"/" + baseUrl + "\","  unless line.indexOf(targetParam) is -1
            resultContent += line + "\n"
        )
        fs.writeFileSync dstConfigFile, resultContent

        indexContent = fs.readFileSync __dirname + "/" + dir + "/index.html", "utf-8"
        fs.writeFileSync __dirname + "/" + dir + "/index.html", indexContent.replace /\/app\//g, "/"

    grunt.task.registerTask "clean-public", "After build we also must to remove all empty directories.", ->
        emptyDirs = []
        rmdir = (dir) ->
            fs = require("fs")
            path = require("path")
            fileDSstore = path.join(dir, ".DS_Store")
            fs.unlinkSync fileDSstore  if fs.existsSync(fileDSstore)
            list = fs.readdirSync(dir)
            i = 0

            while i < list.length
                filename = path.join(dir, list[i])
                stat = fs.statSync(filename)
                if filename is "." or filename is ".."

                else if stat.isDirectory()                                                                                      # pass these files
                    rmdir filename                                                                                              # rmdir recursively
                else
                i++

                # console.log("FILE:", filename);
                if list.length is 0
                    fs.rmdirSync(dir)                                                                                           # rm filename

        requirejsGruntConfig = grunt.config.getRaw("requirejs")
        dir = requirejsGruntConfig.compile.options.dir
        # TODO      
        # How to fix it? may be here exists some async decision
        rmdir(dir)
        rmdir(dir)
        rmdir(dir)

    grunt.registerTask "pack:clear", "remove file", ->
        done = @async()
        exec = require("child_process").exec
        exec "rm -rf packer/*.*", (e) ->
            if e
                grunt.log.error e
            else
                grunt.log.ok "File removed success"
                done()

    grunt.registerTask "pack:copy", "Move packfile to auto-deploy dir", ->
        done = @async()
        exec = require("child_process").exec
        exec "cp packer/*.* " + String(grunt.config.get("vars").autoDeployDir), (e) ->
            if e
                grunt.log.error e
            else
                grunt.log.ok "File copied success"
                done()

    grunt.registerTask "pack:host", "remove file", ->
        done = @async()
        exec = require("child_process").exec
        spawn = require("child_process").spawn
        uname = spawn("uname", ["-n"])
        uname.stdout.on "data", (data) ->
            hostName = String(data).replace(/^\s+|\s+$/g, "")                                                                   # triming string
            grunt.config.set "serverHostname", hostName
            grunt.log.ok "config set to:" + grunt.config.get("serverHostname")
            done()

    grunt.registerTask "teamcity:pack", ["pack:clear", "compress", "pack:copy"]
    grunt.registerTask "teamcity", ["teamcity:pack", "default"]                                                                 #  — teamcity
    grunt.registerTask "auto-deploy", ["pack:host", "default"]                                                                  #  — auto-build server
    grunt.registerTask "public-deploy", []                                                                                      #  — public



    grunt.event.on "regarde:file", (status, name, filepath, tasks, spawn) ->

        console.log "regarde:file", status

        changedFilePath = filepath
        console.log "Changed: " + changedFilePath
        srcScripts = []
        filesToDelete = []
        filesToCopy = []
        relativePath = undefined
        lastIndex = undefined
        srcScripts.push changedFilePath                                                                                         # Push to array, which is the value of parsejs.multiple.src
        fileExtention = "js"
        destForCopyTask = "copiedSpec/"
        editor = "Sublime Text 2"
        scriptsBaseDir = "app/scripts"
        specBaseDir = "test/spec"
        specPrefix = "spec"
        specIndexJs = "test/SpecIndex.js"
        specTemplate = "templates/spec.js"
        relativePath = changedFilePath.replace(scriptsBaseDir, "")
        lastIndex = relativePath.lastIndexOf(".")
        relativePath = relativePath.substr(0, lastIndex)
        relativePath = relativePath + "." + fileExtention
        filesToCopy.push relativePath
        filesToDelete.push relativePath

        unless filepath.indexOf(".coffee") is -1
            pathFragments = filepath.split("/")
            unless pathFragments[pathFragments.length - 1].indexOf(".coffee") is -1
                filename = pathFragments.pop()
                filename = filename.substr(0, filename.lastIndexOf(".coffee")) + ".js"
                pathFragments.push filename  

                #remove 0 element, it must be === root folder, additionaly we can check it on correspondence to coffeescript root folder
                if pathFragments[0] != "tests"
                    pathFragments.shift()
                    pathFragments.unshift "app"
                pathFragments[1] = "js"  if pathFragments[1] is "coffee"
                coffeeToJsResultPath = pathFragments.join("/")

        gruntOptions =
            less:
                development:
                    options:
                        paths: ["static"]
                    files:
                        "static/global/css/global.css": "static/global/less/global.less"
            copy:
                main:
                    files: [
                        expand: true
                        src: filesToCopy
                        dest: destForCopyTask
                    ]

            clean:                                                                                                              # Before generating new file, remove previously-created css file.
                tests: filesToDelete

            autocreationtests:
                multiple:
                    src: srcScripts
                    changedFilePath: changedFilePath
                    specBaseDir: specBaseDir
                    specIndex: specIndexJs                                                                                      # Here's must be listed all incoming tests (the same path structure as the source .js file)
                    specPrefix: specPrefix
                    relativePath: relativePath                                                                                  # Computed relative path
                    specTemplate: specTemplate
                    editor: editor
                    openfile: true                                                                                              # Open file with editor?

            coffee:
                options:
                    bare: true
                compileChanged:
                    files: {}

        

        unless filepath.indexOf("SpecRunner") is -1
            console.log "RECENT", coffeeToJsResultPath, filepath

            filepathArr = []
            filepathArr.push('app/coffee/requireConfig.coffee')
            filepathArr.push filepath
            gruntOptions.coffee.compileChanged.files[coffeeToJsResultPath] = filepathArr
        else
            gruntOptions.coffee.compileChanged.files[coffeeToJsResultPath] = filepath

        console.log gruntOptions.coffee.compileChanged.files

        grunt.initConfig gruntOptions                                                                                           # grunt reinit config
        grunt.option('force', true)                                                                                             # make grunt process stable to coffee compile errors
        grunt.task.run "coffee:compileChanged"  unless filepath.indexOf(".coffee") is -1                                        # only if filepath ends with ".coffee"   
