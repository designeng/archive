define ["underscore", "marionette", "vent", "hbs!templates/modules/core/root/rootLayoutTpl"], (_, Marionette, vent, rootLayoutTpl) ->

    RootLayout = Marionette.Layout.extend

        template: rootLayoutTpl

        className: "rootLayout"

        regions:{
            
        }

        initialize: ->


        onRender: ->
