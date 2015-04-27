define ["underscore"
        "marionette"
        "vent"
        "hbs!templates/core/modules/page/pageLayoutTpl"
        "core/ioc/startComponentInRegion"        
        ], (_, Marionette, vent, pageLayoutTpl, startComponentInRegion) ->

    # ModuleWrapperViewModel

    ModuleWrapperViewModel = Backbone.Model.extend
        initialize: (options) ->
            @on "change:status", @onChange
        onChange: () ->
            # do smth additional on change

    # ModuleWrapperView

    ModuleWrapperView = Marionette.ItemView.extend
        
        className: "moduleWrapper"

        initialize: (options) ->

            @model = Marionette.getOption @, "model"
            name = @model.get("name")

            startComponentInRegion.call(@, name, new Backbone.Marionette.Region({el: @$el}))

            _.bindAll @, "onModelStatusChanged"
            @model.on "change:status", @onModelStatusChanged

        onModelStatusChanged: () ->
            status = @model.get "status"
            if status == "open"
                @showView()
            else if status == "shut"
                @closeView()

        showView: ->
            @$el.show('slow')

        closeView: ->
            @$el.hide('slow')

    # RegionCollectionView

    RegionCollectionView = Marionette.CollectionView.extend
        itemView: ModuleWrapperView

        initialize: (options) ->
            @opened = []
            @shuted = []
            @collection = new Backbone.Collection()

        processConfig: (config) ->
            if !config.open
                return "No elements - close all if they were opened"
            # open or shut just by status change - all logic in ModuleWrapperView.onModelStatusChanged
            for name in config.open
                if name
                    modelSetToCheck = @collection.where({name: name})
                    if !modelSetToCheck[0]   
                        model = new ModuleWrapperViewModel(
                                name: name
                                status: "open"
                            )
                        @collection.add model
                    else if modelSetToCheck[0].get("status") == "shut"
                        modelSetToCheck[0].set "status", "open"

            for name in config.shut
                if name
                    modelSet = @collection.where({name: name})
                    if modelSet.length
                        modelSet[0].set("status": "shut")

            @collection.models


    # PageLayout 

    return Marionette.Layout.extend

        template: pageLayoutTpl

        className: "pageLayout"

        regions: {
            # no regions initially
        }

        initialize: (options) ->
            @regionSet = {}
            @rm = @regionManager

            # "region:add" is built-in regionManager Marionette event
            @rm.on "region:add", (name, region) =>
                @regionSet[name] = {}
                @regionSet[name].region = region
                view = @regionSet[name].view = new RegionCollectionView();
                view.setElement(region.el)
                # @regionSet[name].region.show view

        # calls once at least in runDisplayProcess method in pageController
        process: (pageWorkFlow) ->
            for item of pageWorkFlow
                # create appropriate region if not exists
                if !@regionSet[item]
                    $("<div id='#{item}'></div>").appendTo(@el)
                    @rm.addRegion item, '#' + item

                @reorganizeBlocksInRegion item, @rm.get(item), pageWorkFlow[item]

        # Maybe our name system will be changed somewhere. But now let it be: modules (they are components) are rendered in in the corresponding blocks in regions
        reorganizeBlocksInRegion: (item, region, config) ->
            @regionSet[item].view.processConfig(config)