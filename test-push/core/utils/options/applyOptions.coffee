define ["marionette"], (Marionette) ->
    applyOptions = (options, opt) ->
        attrs = _.toArray(arguments).slice(0)
        # check for opt
        opt = _.last attrs
        if _.isObject(opt) and opt.prefix
            prefix = opt["prefix"]
        else
            prefix = ""

        attrs = _.first attrs

        for attr in attrs
            @[prefix + attr] = Marionette.getOption @, attr