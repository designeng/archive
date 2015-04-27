define ["marionette"
        "vent"
        "appinstance"
        "baseModule"
        "rootController"
], (Marionette, vent, App, BaseModule, RootController) ->

    rootModule = App.module "RootModule", (rootModule, App) ->

        rootController = null

        @startWithParent = false

        rootModule.on "before:start", () ->
            vent.on "rootrouter:init", -> 
                console.log "rootrouter:init"

    
        # Initializers & Finalizers
        rootModule.addInitializer (args) ->
            rootController = new RootController (
                    app: App
                    module: rootModule
                )

        rootModule.addInitializer ->
            vent.on "someEvent", ->
                rootController.someFunc()

        rootModule.on "start", () ->

        rootModule.addFinalizer ->
            if rootController
                rootController.close()
                rootController = null