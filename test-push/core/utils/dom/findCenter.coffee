define ["jquery"], ($) ->
    findCenter = (elem) ->
        offset = undefined
        document = $(elem.ownerDocument)
        elem = $(elem)
        offset = elem.offset()
        x: offset.left + elem.outerWidth() / 2 - document.scrollLeft()
        y: offset.top + elem.outerHeight() / 2 - document.scrollTop()