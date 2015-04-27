define ["marionette"
        "appinstance"
        ], (Marionette, App) -> 

    _controller = null

    class BaseModule
        constructor: (options) ->
            @options = options || {}
            name = @options.name
            controller = @options.controller
            startWithParent = @options.startWithParent

            if !name
                throw new Error "BaseModule needs options.name param!"
            if !controller
                throw new Error "Controller for BaseModule is not defined!"

            @module = @getModule name, @options

        start: (options) ->
            @module.start options

        addInitializer: (options) ->
            @module.addInitializer options

        getController: ->
            _controller

        getModuleLayoutEl: () ->
            @module.controller.layout.$el

        getModuleLayout: () ->
            @module.controller.layout
        
        getModule:(moduleName, options) ->
            return App.module(moduleName, (Module, App, Backbone, Marionette, $, _, _options) ->

                @startWithParent = _options.startWithParent
                _controller = @controller = _options.controller
             
                # Public Data And Functions - they will be accessed by module sandbox
                Module.show = ->
                    @controller.show()
                
                # Initializers & Finalizers
                Module.addInitializer (args) -> 
                    if args
                        options = 
                            region: args.region
                    else
                        options = {}

                    _.extend options, {app: App}

                    if @controller["show"]
                        @controller.show()

            , options)

        # may be module registrator is not needed
        getSubmodules: ->
            @module.submodules