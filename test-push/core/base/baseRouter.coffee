define ["marionette", "vent", "meld", "_.str"], (Marionette, vent, meld) ->
    class BaseRouter extends Marionette.AppRouter

        controller: {
            # No methods here - they will be created in initRouteMethod
            onRuLocale: ->
                @navigateToLocale("ru")
            onEnLocale: ->
                @navigateToLocale("en")
            onDeLocale: ->
                @navigateToLocale("de")
            onEsLocale: ->
                @navigateToLocale("es")
            onLvLocale: ->
                @navigateToLocale("lv")

            navigateToLocale: (loc) ->
                console.log "switched to locale: " + loc
        }

        initialize: (options) ->
            @profile = Marionette.getOption @, "profile"

            @name = Marionette.getOption @, "name"
            @routeProcessor = Marionette.getOption @, "routeProcessor"

            @appRoutes = {
                "!/ru": "onRuLocale"
                "!/en": "onEnLocale"
                "!/de": "onDeLocale"
                "!/es": "onEsLocale"
                "!/lv": "onLvLocale"
            }


            if @routeProcessor
                @processConfiguration()
            else 
                throw new Error "No routeProcessor defined"

        ############################## new route configuration processor #################################
        processConfiguration: () ->
            @routeConfiguration = @routeProcessor.getRouteMap()
            routes = _.keys @routeConfiguration
            @makeNewConfigRouteMethod route for route in routes

        makeNewConfigRouteMethod: (route) =>
            method = @toMethodName route

            config = @routeConfiguration[route]
            @controller[method] = @initRouteMethod @name, route
            @appRoutes[route] = method

        toMethodName: (route) ->
            fragments = @routeProcessor.getFragments route
            if fragments[0] == "!/"
                fragments.shift()
            res = "do"
            if !fragments.length
                return res + "Default"
            for f in fragments
                res += _.str.capitalize f
            res

        initRouteMethod: (name, route) ->
            self = @
            func = () ->
                param = Array::slice.call(arguments, 0)
                console.log "ROUTED TO", name, route, "PARAM ARRAY:", param
                # create configuration for current route - the result will be sent to page renderer
                config = self.createPageCongif(name)

                vent.trigger "#{name}router:getpageconfig", {route: route, param: param}
            return func

        createPageCongif: (name) ->
            routeModel = @controller.find

    # meld actions
    beforeRoute = ->
        console.log "beforeRoute"

    routeRemBefore = meld.before BaseRouter::controller, "onEnLocale", beforeRoute
    # /meld actions

    return BaseRouter









                
