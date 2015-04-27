define [
    "backbone" 
    "vent"
    "routemap"
], (Backbone, vent, routeMap) ->

    ROOT_ROUTE = "!/"

    RouteModel = Backbone.Model.extend
        defaults:
            route: ROOT_ROUTE
            prev: null
            cur: "!"
            map: {}
            level: 0
            next: null

    RouteCollection = Backbone.Collection.extend()

    class RouteProcessor
        instance: undefined
        routeMap: routeMap
        collection: new RouteCollection

        init: ->
            @processRouteMap()

            vent.on "rootrouter:getpageconfig", @makePageConfig

        getRouteMap: ->
            @routeMap

        getCollection: ->
            @collection

        processRouteMap: ->
            rm = @getRouteMap()

            # define root model in first
            rootRoute = rm[ROOT_ROUTE]
            if !rootRoute
                throw new Error "rootRoute does not defined in routeMap!"

            rootRouteModel = new RouteModel(
                    map: rm[ROOT_ROUTE]
                )

            @collection.add rootRouteModel    

            for route of rm
                if route == ROOT_ROUTE 
                    continue

                rModel = @createRouteModel(rm, route, rm[route])

                @collection.add rModel

        createRouteModel: (rm, route, config) ->
            fragments = @getFragments route

            level = @getRouteLevel fragments

            prev = fragments[level - 1]
            cur = fragments[level]

            rModel = new RouteModel({
                        route: route
                        map: rm[route]
                        level: level
                        prev: prev
                        cur: cur
                    })

        getFragments: (route) ->
            fragments = []
            parts = route.split "/"
            for p in parts
                fragments.push p if p isnt ""
            fragments

        getRouteLevel: (fragments) ->            
            fragments.length - 1

        # finnaly create configuration for current route
        makePageConfig: (evtData) =>
            map = {}
            route = evtData.route
            fragments = @getFragments(route)
            for frag in fragments
                model = (@collection.where {cur: frag})[0]
                _.extend map , model.get "map"

            # merged (extended) model:
            vent.trigger "routeprocessor:pagemap:created", {map: map, param: evtData.param}

        getModelAttr: (model, attr) ->
            value = model.get attr
            if !value 
                return false
            else
                return value

        getInstance: ->
            instance = new RouteProcessor()  unless instance
            instance
  
    routeProcessor = new RouteProcessor()
    routeProcessor = routeProcessor.getInstance()
    routeProcessor