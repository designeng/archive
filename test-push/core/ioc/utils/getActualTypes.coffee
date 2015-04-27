define ->
    getActualTypes = (str) ->
        # TODO: Optimize it!
        # TODO: think about injection format (inject: ["typeOne", "typeTwo"... etc])

        types = []

        itemTypeRx = /(itemType:\s*)("(.*?)")|(headerType:\s*)("(.*?)")|(bodyType:\s*)("(.*?)")|(innerComponentType:\s*)("(.*?)")/g
        matchs = str.match(itemTypeRx)

        # console.log matchs

        if matchs
            for item in matchs
                t = item.match /Type:\s*/g
                types.push item.slice(item.indexOf(t[0]) + t[0].length).replace(/"/g, "")

                # types.push item.replace(itemTypeRx, "$2$5$8").replace(/"/g, "")

        types = _.uniq types

        # console.log types

        return types
