define [
    "marionette"
    "Handlebars"
    "appinstance"
    "vent" 
    "meld"
    "routeProcessor"
    "i18n!nls/general"
    "rootModule"
    "pageModule"
    "renderingService"
    "require"
    "handlebarsHelpers"
    "overridden"
    "extended"
], (
    Marionette
    Handlebars
    App
    vent
    meld
    routeProcessor
    localized
    rootModule
    PageModule
) ->

    App.on "initialize:before", ->
        routeProcessor.init()
        return true

    # marionette app events...
    App.on "initialize:after", ->
        Backbone.history.start()
        Backbone.history.bind "all", (route, router) ->
            vent.trigger "history:changed", {hash: window.location.hash}

    App.addInitializer ->
        pageModule = new PageModule                            # PageModule is wrapper for BaseModule object - but BaseModule returns Marionette.Module
            region: App.application

        pageModule.start
            startWithParent: false

        rootModule.start
            startWithParent: false        

    ApplicationRegion = Marionette.Region.extend                # here we create the region of new type: ApplicationRegion
        el: "#application"
        onShow: ->
            vent.trigger "appregion:showed"

    # add App regions
    App.addRegions application: ApplicationRegion
    App.addRegions debug: "#debug"
    App.addRegions debugMore: "#debug-more"

    return App
