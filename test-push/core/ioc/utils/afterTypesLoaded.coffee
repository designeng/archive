define [
    "resolver"
    "when"
    ], (resolver, When)->
    afterTypesLoaded = (types, callback, errback) ->
        # deferred = When.defer()

        promises = []         

        # this trick has only one goal - to provide early loading of requirejs-modules
        # before they will be injected with synchronized version of 'require' 
        for type in types
            promise = When.promise( (resolve, reject, notify) ->
                    resolver.resolve type, resolve, reject, (classType) ->
                        # do smth additional with loaded classType
                        # deferred.resolve classType
                )
            promises.push promise

        When.all(promises).then(callback, errback)

        # return deferred.promise
