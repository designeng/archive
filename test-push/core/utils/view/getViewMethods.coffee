define ["backbone", "marionette", "underscore"], (Backbone, Marionette, _) ->
    differenceBetween = (target, arr) ->
        for item in arr
            target = _.difference target, item
        return target

    getViewMethods = (shadow) ->
            # entities to get difference between 
            eventProps = []
            for prop of Backbone.Events
                eventProps.push prop

            viewProps = []
            for prop of Marionette.View::
                viewProps.push prop

            itemViewProps = []
            for prop of Marionette.ItemView::
                itemViewProps.push prop

            layoutViewProps = []
            for prop of Marionette.Layout::
                layoutViewProps.push prop

            collectionViewProps = []
            for prop of Marionette.CollectionView::
                collectionViewProps.push prop

            compositeViewProps = []
            for prop of Marionette.CompositeView::
                compositeViewProps.push prop
            # /entities


            targetObjectProps = []
            for prop of @
                if _.isArray shadow
                    if prop in shadow
                        do ->
                            return "nothing"
                    else if _.isFunction @[prop]
                        targetObjectProps.push prop
                else
                    if _.isFunction @[prop]
                        targetObjectProps.push prop

            actualProps = differenceBetween targetObjectProps, [eventProps, viewProps, itemViewProps, layoutViewProps, collectionViewProps, compositeViewProps]

            return actualProps

