define [
        "core/utils/options/applyOptions"
], (applyOptions) ->

    BaseControllerObject = {
        applyOptions: (options, opt) ->
            applyOptions.call @, options, opt
    }

    return BaseControllerObject