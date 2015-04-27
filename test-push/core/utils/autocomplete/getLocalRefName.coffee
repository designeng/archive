define [], ->
    # sort = (list) ->
    #     list = list.sort((a, b) ->
    #       a - b
    #     )
    #     list

    charToUpper = (str) ->
        str = str.charAt(0).toUpperCase() + str.slice(1)
        str

    getLocalRefName = (locale) ->
        "name" + charToUpper(locale)

    return getLocalRefName

    # getLocalRefName: getLocalRefName
    # sort: sort