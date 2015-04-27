define ["backbone"], (Backbone) ->
    randomStr = (l, mode) ->
        modes ={
            letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            numbers: "0123456789"
            both: @letters + @numbers
        }        

        i = 0; text = ""
        while i < l
            text += modes[mode].charAt(Math.floor(Math.random() * modes[mode].length))
            i++
        text

    # @param {Object} options The options for generating
    # @param {string} options.prefix Default "item"
    # @param {string} options.mode "letters|numbers|both" default "letters"
    collectionGenerator = (count, attributes, options) ->
        options = options || {}
        options["mode"] = options["mode"] || "letters"
        options["prefix"] = options["prefix"] || "item"

        collection = new Backbone.Collection()
        countforward = (num for num in [0..count])
        obj = {}
        for c in countforward
            for attr in attributes
                if options.mode
                    obj[attr] = randomStr(5, options.mode)
                obj[attr] += "_" + options.prefix + c
            c = new Backbone.Model(obj)
            collection.add c
        return collection

