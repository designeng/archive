define ["underscore", "flat"], (_, flat) ->
    attributesToString = (obj) ->
        str = ""
        if obj.attributes
            _obj = obj.attributes
        else
            _obj = obj

        fl = flat.flatten _obj
        for attr of fl
            str += attr + ': "' + fl[attr] + '"\n'

        return str