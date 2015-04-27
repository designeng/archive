define [
    "resolver"
    "when"
    "core/ioc/utils/getActualTypes"
    "core/ioc/utils/afterTypesLoaded"
], (resolver, When, getActualTypes, afterTypesLoaded) ->

    startComponentInRegion = (name, region) ->
        # component must be loaded first
        require [
                "modules/" + name + "/" + name + "Controller"
                "text!modules/" + name + "/declaration.js"
                "modules/" + name + "/declaration"], 
        (ControllerClass, declarationAsText, declaration) => 

            types = getActualTypes(declarationAsText)

            callback = (res) =>
                @controller = new ControllerClass(
                        region: region
                        declaration: declaration
                        context: @
                    )

                # if show method provided by controller, it will be invoked
                if @controller["show"]
                    @controller.show()

            errback = (err) =>
                console.log "ERROR", err

            afterTypesLoaded(types, callback, errback)