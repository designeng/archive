define ["backbone"
        "marionette"
        "meld"
        "hbs!templates/component/default/defaultComponentTpl"
        "core/base/component/item/itemView"
        "core/base/component/utils/defineTargetElement"   
        ], (Backbone, Marionette, meld, DefaultComponentTpl, ControlItemView, defineTargetElement) ->

    ComponentCompositeView = Marionette.CompositeView.extend

        template: ->
            Marionette.getOption @, "template"

        className: "CompositeView"

        itemView: ControlItemView

        itemViewOptions: (model, index) ->
            attributes =
                control: model.attributes.controlType
                model: "controlModel" # here we marked attribute from where control model will be retrieved
                dataModel: model.attributes.dataModel
            options = {}
            options.attributes = attributes
            return options

        beforeInitialize: () ->
            @declaration = Marionette.getOption @, "declaration"
            if @declaration.componentModel
                @model = @declaration.componentModel

                componentType = @model.get "componentType"
                if componentType is "form"
                    @isForm = true
                    return "form"
                else if componentType is "popup"
                    @isPopup = true

            else
                # component is not a form - return default tagName
                @model = new Backbone.Model()

        initialize: (options) ->
            # for element binding in appendHtml
            # TODO: to think: is not potentialy dangerous? some previosly defined model with the same cid can be re-defined...
            @model.set "cid", @cid

            componentItems = @declaration.componentItems
            @context = Marionette.getOption @, "context"

            # for simplicity and error communication report to context about inputErrorHandlerCid

            if @declaration.componentModel && @declaration.componentModel.has "controller"
                controller = @declaration.componentModel.get "controller"
                # ensure controller dataModel && action
                controller = _.extend(controller,
                        { 
                            action: @declaration.componentModel.get "action", 
                            dataModel: @declaration.componentModel.get "dataModel"
                            ajax: @declaration.componentModel.get "ajax"
                        }
                    )
                # maybe not the best
                @context = _.extend(@context, controller)

            # define context.validator # ?
            if @isForm
                @context.validator = {}

            if @isForm && @model.has "inputErrorHandlerCid"
                _inputErrorHandlerCid = @model.get "inputErrorHandlerCid"
                # set inputErrorHandlerCid as property to @context
                @context.inputErrorHandlerCid = _inputErrorHandlerCid

            #  transmit dependencies
            for item in componentItems
                item.controlModel.set {"context": @context}

                #  transmit further "inputErrorHandlerCid" attribute to collection models
                if @isForm && @model.has "inputErrorHandlerCid"
                    # and set inputErrorHandlerCid as property to item.controlModel
                    item.controlModel.set {"inputErrorHandlerCid": _inputErrorHandlerCid}   

            if @declaration.componentModel
                @_rootClass = @declaration.componentModel.get("rootClass")
                itemClasses = @declaration.componentModel.get("itemClasses")

                if @_rootClass && itemClasses
                    @className = @_rootClass
                    itemClasses = _.map itemClasses, (item) =>
                        return @_rootClass + "__" + item + " " + @_rootClass + "__item"

                    @model.set "itemClasses", itemClasses

            @collection = new Backbone.Collection(componentItems)

        onRender: ->
            if @isForm
                attributes = _.extend({}, _.result(@, 'attributes'))

                # action for tagName = "form" will be added
                extention = {'class': @className, "action": @model.get "action"}

                attrs = _.extend(attributes, extention)
                @$el.attr(attrs)

        # report by triggering to @context about every added item
        onAfterItemAdded: (itemView) ->
            @context.trigger "component:collection:item:added", itemView

        appendHtml: (collectionView, itemView, index) ->
            targetElement = defineTargetElement.call @, collectionView, index                    

            # pass down the class to itemView for BEM realization
            itemView.setRootClass(targetElement.attr "class")

            # as itemView.$el will be changed after control inserting, we must re-appoint root element (Backbone.view.$el)
            itemView.setRootElement(targetElement)

            if @isPopup
                targetElement = $('.pageContainer') if itemView.model.get('controlModel').get('outsideRender')

            targetElement.append itemView.el


    # defined before aspect for ComponentCompositeView::initialize method
    @remBefore = meld.before ComponentCompositeView::, "initialize", ComponentCompositeView::beforeInitialize

    # return Component as wrapper controller for strategically important ComponentCompositeView
    return Component = Marionette.Controller.extend

        # template will be received from this field if no template defined in initialize options
        template: DefaultComponentTpl

        initialize: (options) ->

            @region = Marionette.getOption @, "region"

            @layout = new ComponentCompositeView(
                    declaration: Marionette.getOption @, "declaration"
                    context: Marionette.getOption @, "context"
                    template: Marionette.getOption @, "template"
            )

        getChildren: ->
            @layout.children   

        show: ->
            @region.show @layout

        close: ->
            @region.close()
