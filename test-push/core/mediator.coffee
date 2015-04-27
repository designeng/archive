define ["vent"], (vent) ->
    class Mediator
        constructor: ->
            # events and actions
            vent.on "routeprocessor:pagemap:created", @onRouteConfigComplited

            vent.on "history:changed", @onHistoryChanged

            vent.on "collected:data", @onCollectedData



        # config for current route is created, throw it to pageModule
        onRouteConfigComplited: (evtData) =>
            # should be service - mapping params to component (module)
            @currentParam = evtData.param

            vent.trigger "display:modules", evtData

        onHistoryChanged: (evtData) =>

        onCollectedData: (evtData) =>
            vent.trigger "mediator:collected:data", evtData

        # get param from mediator ???
        getCurrentParam: ->
            return @currentParam




    return mediator = new Mediator()