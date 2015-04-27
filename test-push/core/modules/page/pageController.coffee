define ["marionette"
        "pageLayout"
        "regionModuleRegistrator"], (Marionette, Layout, RegionModuleRegistrator) ->

    # PageWorkFlow = Backbone.Model.extend

    PageController = Marionette.Controller.extend
        initialize: (options) ->
            @region = Marionette.getOption @, "region"
            @regionModuleRegistrator = new RegionModuleRegistrator(@);

        show: ->
            @layout = new Layout(
                model: new Backbone.Model(
                    
                )
                ventObj: @ # this controller acts as pub/sub system (but actually it's not used)
            )
            @region.show @layout

        hide: ->
            @region.close()

        # displayModules in public api of pageModule
        # @param {Object} evtData Event data
        displayModules: (evtData) ->
            config = evtData.map
            param = evtData.param

            $.when(@regionModuleRegistrator.registerConfig config).then((pageWorkFlow) =>
                    @runDisplayProcess pageWorkFlow
                )

        # display process imposed externally - in @layout
        runDisplayProcess: (pageWorkFlow) ->
            # for item of pageWorkFlow
            #     console.log item, pageWorkFlow[item]
            @layout.process pageWorkFlow
