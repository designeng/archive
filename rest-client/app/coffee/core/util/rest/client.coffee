define [
    "underscore"
    "rest"
    "rest/interceptor/mime"
    "rest/interceptor/entity"
], (_, rest, mime, entity) ->

    class Client

        builtInInterceptors: [
            "mime"
            "entity"
        ]

        constructor: ->
            interceptors = Array::slice.call(arguments)
            client = _.reduce interceptors, (result, interceptor) =>
                if interceptor not in @builtInInterceptors
                    throw new Error "Unknown interceptor!"
                if interceptor is "mime"
                    return eval("result.wrap(#{interceptor}, { mime: 'application/json' })")
                else
                    return eval("result.wrap(#{interceptor})")
            , rest
            return client
