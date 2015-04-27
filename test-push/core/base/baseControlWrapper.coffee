define ["marionette"
        "i18n!nls/general"
        "core/aop/extentions/controlExtentions"
], (Marionette, localized, controlExtentions) ->

    BaseControlWrapper = Marionette.ItemView.extend
        initialize: (options) ->
            @getControlByType @model.get("controlType")

        getControlByType: (controlType) ->
            require [controlType], (control) =>
                @addInnerControl(control)

        addInnerControl:(controlTypeView) ->
            @model.set {"context": @} unless @model.has "context"

            @childView = new controlTypeView
                model: @model

            @childView = _.extend(@childView, controlExtentions, {localized: localized})

            @renderInnerControl @childView

        renderInnerControl: (view) ->
            @$el.html(view.render().el)