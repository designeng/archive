define ["baseRouter"], (BaseRouter) ->

    class RootRouter extends BaseRouter

        initialize: (options) ->
            options = options || {}
            @name = options.name
            @routeProcessor = options.routeProcessor
            super options

        before: ->
            console.log "BEFORE Router started"

        appRoutes: {
            #leave it blank
        }
