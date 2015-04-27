define [
        "backbone"
        "marionette"
        "baseControl"
        "controlContainerService"
        "hintControl"
        "inputError"
        ], (Backbone, Marionette, BaseControl, controlContainerService, HintControl, InputErrorControl) ->

    BaseInput = BaseControl.extend

        className: ->
             @defaultClassName("inputControl")

        initialize: (options) ->
            @model.set "__input_instance", true unless @model.has "__input_instance"

            if hintModel = @model.get "hint"
                @hint = new HintControl(
                        model: hintModel
                    )

            if @model.has "inputErrorHandlerCid"
                @inputError = controlContainerService.findByCid(@model.get "inputErrorHandlerCid")
            else
                @inputError = new InputErrorControl(
                        model: new Backbone.Model()                  
                    )

        # BaseInput aspects
        beforeBaseInputRender: ->
            @model.set "isValid", true         

        afterBaseInputRender: ->
            for prop in ["width", "height", "fontSize"]
                if @model.has prop
                    @$el.find("input").css(prop, @pixelize(@model.get prop))


        # this util method must be removed subsequently from BaseInput
        # BaseInput - only for attaching @inputError / @hint (Separation of Concerns!!!)
        pixelize: (width) ->
            return width + "px"


    return BaseInput
