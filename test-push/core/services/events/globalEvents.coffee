define ["jquery", "marionette"], ($, Marionette) ->

    GlobalEvents = Marionette.Controller.extend
        initialize: ->
            # window resize event
            $(window).resize () =>
                @trigger "window:resize",
                    width: $(window).width()
                    height: $(window).height()

            # html click event
            $("html").click (e) =>
                @trigger "html:click", e

    # should be singleton
    return globalEvents = new GlobalEvents() unless globalEvents?
