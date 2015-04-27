define [
    "core/aop/extentions/controlExtentions"
    "core/utils/view/applyModelPropertiesToViewProperties"
    "core/utils/options/applyOptions"
    "core/aop/utils/afterRenderAspect"
    "i18n!nls/general"
], (controlExtentions, applyModelProperties, applyOptions, afterRenderAspect, localized) ->

    BaseViewObject = {

        _attrPrefix: "_"

        localized: localized

        prepareLocalized: controlExtentions.prepareLocalized

        defaultClassName: (name) ->
            if @model.has "className"
                return @model.get "className"
            else
                return name

        applyModelProperties: (properties, options) ->
            applyModelProperties.call @, properties, options

        applyOptions: (options, opt) ->
            applyOptions.call @, options, opt

        afterRenderAspect: ->
            afterRenderAspect.call @  
    }

    return BaseViewObject