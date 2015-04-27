define ->
    defineTargetElement = (collectionView, index) ->
        if @_rootClass
            targetElement = collectionView.$el.find("[data-id='element__#{index}']")
            if !targetElement.length
                throw new Error "HTML element with data-id='element__#{index}' is not found! Check your template"
        else
            # backward compatibility with defining element throw cid
            targetElement = collectionView.$el.find("[data-id='#{@cid}__#{index}']")
            if !targetElement.length
                throw new Error "HTML element with data-id='#{@cid}__#{index}' is not found! Check your template"
        return targetElement

