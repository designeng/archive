define ["marionette"], (Marionette) ->
    # ======================== TemplateCache ==========================================
    # configure for loading templates stored externally...
    Marionette.TemplateCache::loadTemplate = (templateId) ->
        #  Marionette expects "templateId" to be the ID of a DOM element.
        #  But with RequireJS, templateId is actually the full text of the template.
        template = templateId
  
        # Make sure we have a template before trying to compile it
        if not template or template.length is 0
            # msg = "Could not find template: '" + templateId + "'"
            # err = new Error(msg)
            # err.name = "NoTemplateError"
            # throw err
            template = " "

                 
        template

    Marionette.TemplateCache::compileTemplate = (rawTemplate) ->
        if !_.isFunction rawTemplate
            Handlebars.compile rawTemplate
        else 
            return rawTemplate





