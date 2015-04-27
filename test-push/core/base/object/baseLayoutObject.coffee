define [
    "renderingService"
], (renderingService) ->

    BaseItemViewObject = {
        getRenderingService: ->
            return renderingService 
    }

    return BaseItemViewObject