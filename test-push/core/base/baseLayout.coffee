# Thanks for idea https://github.com/loicfrering/backbone.handlebars/blob/master/src/view.js
define ["marionette"], (Marionette) ->

    BaseLayout = Marionette.Layout.extend
        initialize: (options) ->
            console.log "INIT"