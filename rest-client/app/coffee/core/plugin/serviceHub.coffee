define [
    "underscore"
    "when"
    "meld"
    "core/servicehub/serviceMap"
    "core/util/rest/client"
    "core/servicehub/response/index"
    "core/util/net/isOnline"
    "core/util/navigation/navigate"
    "core/util/navigation/navigateToError"
], (_, When, meld, serviceMap, Client, serviceResponse, isOnline, navigate, navigateToError) ->

    return (options) ->

        removers = []

        # serviceMap[service][path] can be configured with params in curved brackets
        # e.g. "fragmentOne/fragmentTwo/{param}"
        patchPath = (path, data) ->
            return _.reduce data, (result, value, key) ->
                result.replace("{#{key}}", value)
            , path

        afterSendRequestAspect = (target) ->
            if target["afterSendRequest"]
                removers.push meld.after target, "sendRequest", (resultEntityPromise) =>
                    When(resultEntityPromise).then (resultEntity) ->
                        target["afterSendRequest"].call(target, resultEntity)
            if target["onRequestError"]
                removers.push meld.after target, "sendRequestErrback", () ->
                    target["onRequestError"].call(target)

        service = (facet, options, wire) ->
            target = facet.target
            services = facet.options

            if _.isArray services
                deferred = When.defer()
                target.services = {}
                target.client = new Client("mime", "entity")

                target["sendRequestSuccess"] = (response, serviceName) ->
                    serviceResponse.storeResponse(serviceName, response)        # store response in localstorage via serviceResponse object
                    deferred.resolve(response)

                target["sendRequestErrback"] = (response) ->
                    navigateToError('js', 'Server response error')

                target["sendRequest"] = (serviceName, data, pathPatchingData, method) ->
                    data = data || {}
                    path = @services[serviceName].path if @services[serviceName]
                    method = method || @services[serviceName].method || "GET"

                    normalizePath = (path, pathPatchingData) ->
                        unless path
                            throw new Error("Path is not defined in service '#{serviceName}'!")
                        path = patchPath(path, pathPatchingData)
                        return path

                    path = normalizePath(path, pathPatchingData)

                    talkWithClient = ((target, serviceName, method) ->
                        target
                            .client({ path: path, data: data, method: method})
                            .done (response) ->
                                    target["sendRequestSuccess"](response, serviceName)
                                , (response) ->
                                    target["sendRequestErrback"](response)
                    ).bind(null, target, serviceName, method)

                    # DO NOT REMOVE IT (for offline mode)!
                    # talkWithLocalStorage = ((serviceName) ->
                    #     # get response from localstorage via serviceResponse object
                    #     response = serviceResponse.getStoredResponse(serviceName)
                    #     if _.isEmpty response
                    #         alert "Response is empty (no stored response value for service '#{serviceName}')"
                    #     deferred.resolve(response)
                    # ).bind null, serviceName

                    # test first id browser online. it may be promise-based (if ping request)
                    # When(isOnline()).then(talkWithClient, talkWithLocalStorage)

                    When(isOnline()).then(talkWithClient, talkWithClient)

                    return deferred.promise

                afterSendRequestAspect(target)

                _.bindAll target, "sendRequest"

                for serv in services
                    if serviceMap[serv]
                        target.services[serv] = serviceMap[serv]

                    # TODO: return this error to promise reject
                    else
                        throw new Error("Service is not defined! - " + serv)

        bindToServiceFacet = (resolver, facet, wire) ->
            resolver.resolve(service(facet, options, wire))

        return facets: 
            bindToService: 
                ready: bindToServiceFacet
                destroy: (resolver, proxy, wire) ->
                    for remover in removers
                        remover.remove()
                    resolver.resolve()
