define ->

    return afterRenderAspect = ->
        className = if @hasOwnProperty('_className') then @_className else _.result(@, "className")     # if $el not found, there are another elements just contain _className props (non declaration els like popup content).
        className = "#{@compositeClassName}__#{className}" if @compositeClassName
        if className                                                                                    # add class if present
            @$el.addClass(className)



# define ->
#     afterRenderAspect = ->
#         _className = _.result(@, "className")
#         if @compositeClassName
#             # both names
#             className = "#{@compositeClassName}__#{_className}" + " " + _className
#         else
#             className = _className
#         attrs = {
#             "class" : className
#         }
#         @$el.attr(attrs)



