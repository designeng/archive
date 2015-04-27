define ->
    # util function from https://github.com/gmac/backbone.epoxy/blob/master/backbone.epoxy.js#L1158-L1167
    queryViewForSelector = (view, selector) ->
        $elements = view.$(selector)         
        # Include top-level view in bindings search:
        $elements = $elements.add(view.$el)  if view.$el.is(selector)
        $elements