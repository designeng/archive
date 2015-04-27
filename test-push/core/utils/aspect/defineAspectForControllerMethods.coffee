define ["meld", "backbone"], (meld, Backbone) ->
    defineAspectForControllerMethods = (controller, shadow) ->
        # we need get difference between @controller properties and Backbone.Events properties
            eventProps = []
            for prop of Backbone.Events
                eventProps.push prop

            targetObjectProps = []
            for prop of @
                targetObjectProps.push prop

            controllerProps = []
            for prop of @controller
                if !@controller.hasOwnProperty(prop) and prop not in shadow # some properties left in shadow
                    controllerProps.push prop

            # first get difference from Backbone.Events methods
            controllerProps = _.difference controllerProps, eventProps

            actualControllerMethods = _.intersection controllerProps, targetObjectProps

            removers = []
            # meld section
            for method in actualControllerMethods
                removers.push(meld.after @, method, @controller[method])

            return removers

