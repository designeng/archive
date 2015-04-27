define [
    "backbone"
], (Backbone) ->
    return controlContainerService = new Backbone.ChildViewContainer() unless controlContainerService?