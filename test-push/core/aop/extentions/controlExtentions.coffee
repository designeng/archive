define ["underscore"], (_) ->
    prepareLocalized = (opt, resultMode) ->
        prepared = []
        options = []

        # if opt is simple string
        if _.isString opt
            options.push opt
        else if _.isArray opt
            options = _.flatten opt
        else if _.isObject opt
            for o in opt
                if _.isString o
                    options.push o
                else 
                    throw new Error "PrepareLocalized arg structure is too complex!"

        for option in options
                if option and option.slice(0, 4) is "loc_"
                    optionTail = option.slice(4)
                    if @localized[optionTail]
                        if resultMode is "object"
                            resObj = {}
                            resObj[optionTail] = @localized[optionTail]

                            prepared.push resObj
                        else
                            prepared.push @localized[optionTail]
                    else 
                        throw new Error "No accordance in localized for #{option}!"
                else
                    prepared.push option

        if resultMode is "string"
            return prepared[0]
        else
            # object, array, default
            return prepared
    

    extentions =
        prepareLocalized: prepareLocalized

    return extentions

