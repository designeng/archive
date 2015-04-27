define ["marionette"
"vent"
"routeProcessor"
"rootRouter" 
"rootLayout"], (Marionette, vent, routeProcessor, RootRouter, RootLayout) ->

    RootController = Marionette.Controller.extend
        initialize: (options) ->
            @app = Marionette.getOption @, "app"
            @profile = Marionette.getOption @, "profile"
            @module = Marionette.getOption @, "module"

            @module.router = new RootRouter(
                routeProcessor: routeProcessor
                name: "root"
            )

            @module.router.bind "all", (route, router) ->
                # console.log "Different Page: " + route + " " + router

        onClose: ->
