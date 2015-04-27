define ["underscore"], (_)->
    getItemStringLength = (item) ->
        length = 0
        words = 0
        for attr of item.attributes
            val = item.attributes[attr]
            if _.isString val
                length += val.length
                words++

        # words count increase length at least on spaces count
        length += words 
        return length