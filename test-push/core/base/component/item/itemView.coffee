define ["backbone"
        "marionette"
        "meld"
        "resolver"
        "controlContainerService"
        "core/utils/dom/queryViewForSelector"
        "_.str"
], (Backbone, Marionette, meld, resolver, controlContainerService, queryViewForSelector) ->

    # ControlItemView for item-control rendering in core/base/component/baseComponent : ComponentCompositeView

    ControlItemView = Marionette.ItemView.extend

        # no need any more in explicit template; all attributes will be ascribed to main div
        # template: "<div controlType='{{controlType}}' model='controlModel'>"

        setRootClass: (rootClass) ->
            @rootClass = rootClass

        initialize: ->
            @$el.attr @attributes
            @context = (@model.get "controlModel").get "context"
            @dataModel = @model.get "dataModel"

        onRender: ->
            # find all elements with "control" attribute
            controls = queryViewForSelector(@, "[control]")

            _.each(controls, (item) =>
                    controlType = $(item).attr("control")               
                    modelLink = $(item).attr("model")

                    $el = $(item)
                    
                    if _.isObject modelLink #maybe it's never be done
                        model = modelLink
                    else if _.isString modelLink
                        model = @model.get modelLink

                    # core control loading
                    # load specified control type 
                    resolver.resolveControl controlType, (viewClass) =>
                        # and render instance
                        @renderNestedView($el, resolver.resolveControlInstance(viewClass, {model: model, dataModel: @dataModel}), model)
                )

            if @rootClass
                @className = @rootClass

        commonAfterRenderAspect: ->
            context = @model.get "context"
            context.trigger "component:control:rendered", @

        renderNestedView: ($el, view, model) ->
            # register view in controlContainerService
            controlContainerService.add view

            @defineCompositeClassName view

            remCommonAfterRender = meld.after view, "render", @commonAfterRenderAspect

            if view.afterRenderAspect
                remAfterRender = meld.after view, "render", view.afterRenderAspect       

            $el.replaceWith view.$el

            view.render()

        # the part of BEM realization
        # TODO: allocate it in special class (object)
        defineCompositeClassName: (view) ->
            if @rootClass
                compositeClassName = _.filter(@rootClass.split(" "), (name) ->
                        return name unless name in ["", " "] and _.str.endsWith.call(@, name, "__item")
                    )[0]
                view.compositeClassName = compositeClassName
                return compositeClassName

        # currently @$el in blank, so re-appoint it in compositeView
        setRootElement: ($el) ->
            @$el = $el

        hide: ->
            @$el.hide()
        show: ->
            @$el.show()

        beforeClose: ->
            if @modelBinder
                @modelBinder.unbind()

            if @model.has "__input_instance"
                for rem in @removers
                    rem.remove()

    return ControlItemView