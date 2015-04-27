define ["marionette", "vent", "i18n!nls/general", "core/aop/extentions/controlExtentions"], (Marionette, vent, localized, controlExtentions) ->
    BaseFormController = Marionette.Controller.extend

        localized: localized

        prepareLocalized: controlExtentions.prepareLocalized

        # all dataModels will be collected here    
        collection: null

        initialize: (options) ->
            @ajax = true

            if !@collection
                @collection = new Backbone.Collection()

            if !@dataModel
                @dataModel = new Backbone.Model()

            if !@method
                @method = "POST"

            @dataModel.on "change", (model) ->
                # console.log "CHANGED - in baseFormController ", model.attributes

        collectData: (model) ->
            # store in collection
            @collection.add model, {merge: true}

            # and place in dataModel
            name = model.get "name"
            data = model.get "data"
            controlType = model.get "controlType"
            @ensureAttribute(name, data)

            @collectedData = @collection.map((model) =>                    
                    return {
                        name: model.get "name"
                        data: model.get "data"
                        controlType: model.get "controlType"
                    }
                )

            # console.log "collection", @collectedData

        ensureAttribute: (name, data) ->
            @dataModel.set name, data

        # @ object treated as context in dependent controls, and can be called by them
        processData: () ->
            # here we must to do something usefull with collection:
            # store in localStorage;
            # validate, then send to server via rest client or etc.

            @sendAjax()            

        # we are going to inplement sterling rest client, but for a while simple ajax here
        sendAjax: ->
            console.log  "@collectedData", @collectedData

            $.ajax(
                type: @method
                url: @action
                data: @collectedData
            ).done((res)=>
                console.log "sendAjax DONE", res

                vent.trigger "collected:data",
                    data: @collectedData
            )


    return BaseFormController