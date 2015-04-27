define ["marionette"
        "vent"
        "meld"
        "baseModule"
        "pageController"], (Marionette, vent, meld, BaseModule, PageController) ->

    # it acts as SANDBOX for PageModule as Marionette.Module

    class PageModule
        constructor: (options) ->
            @module = new BaseModule(
                    name: "pageModule"
                    controller: new PageController(
                            region: options.region
                        )
                    startWithParent: options.startWithParent
                )

            @initListeners()            

        start: () ->
            @module.start()

        initListeners: ->
            vent.on "display:modules", (evtData) =>
                @module.getController().displayModules evtData