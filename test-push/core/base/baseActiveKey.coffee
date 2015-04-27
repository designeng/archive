define ["underscore"
        "backbone"
        "jquery"
        "core/utils/view/applyModelPropertiesToViewProperties"
        "core/aop/extentions/controlExtentions"
        "i18n!nls/general"
        "core/aop/utils/afterRenderAspect"
], (_, Backbone, $, applyModelProperties, controlExtentions, localized, afterRenderAspect) ->
  
      #        This base view extends what you will pass in options (but it must be Backbone.View or extension of Backbone.View)
      #        and used to complement the view of the events of the keyboard.
      #
      #        Keyboard functionality depends on https://github.com/nervetattoo/backbone.keys/blob/master/backbone.keys.js
      #
      #        Usage example:
      #
      #        var options = {
      #            BaseObject: Marionette.CompositeView
      #        }
      #
      #        var BaseView = KeyActiveBaseObject(options);
      #
      #        var CustomView = BaseView.extend({.....here's the Backbone/Backbone.Marionette way of object defining..... });
      #    });
      #    
    BaseActiveKey = (baseOptions) ->
    
        # Alias the libraries from the global object
        oldDelegateEvents = Backbone.View::delegateEvents
        oldUndelegateEvents = Backbone.View::undelegateEvents
        getKeyCode = (key) ->
            (if (key.length is 1) then key.toUpperCase().charCodeAt(0) else BackboneKeysMap[key])

            
        # Map keyname to keycode
        BackboneKeysMap =
            backspace: 8
            tab: 9
            enter: 13
            space: 32
              
            # Temporal modifiers
            shift: 16
            ctrl: 17
            alt: 18
            meta: 91
              
            # Modal
            caps_lock: 20
            esc: 27
            num_lock: 144
              
            # Navigation
            page_up: 33
            page_down: 34
            end: 35
            home: 36
            left: 37
            up: 38
            right: 39
            down: 40
              
            # Insert/delete
            insert: 45
            delete: 46
              
            # F keys
            f1: 112
            f2: 113
            f3: 114
            f4: 115
            f5: 116
            f6: 117
            f7: 118
            f8: 119
            f9: 120
            f10: 121
            f11: 122
            f12: 123

            
        # Aliased names to make sense on several platforms
        _.each
            options: "alt"
            return: "enter"
        , (real, alias) ->
            BackboneKeysMap[alias] = BackboneKeysMap[real]

            
        #define baseOptions.BaseObject as it descripted above 
        KeyActiveBaseView = baseOptions.BaseObject.extend(

            afterRenderAspect: ->
                afterRenderAspect.call @

            applyModelProperties: (properties, options) ->
                applyModelProperties.call @, properties, options

            # ---------- localization -----------
            # explicitly set localization object and methods
            localized: localized

            prepareLocalized: controlExtentions.prepareLocalized
            # ---------- /localization -----------
              
            # Allow pr view what specific event to use
            # Keydown is defaulted as it allows for press-and-hold
            bindKeysOn: "keydown"
              
            # The Backbone-y way would be to have
            # keys scoped to `this.el` as default,
            # however it would be a bigger surprise
            # considering how you'd expect keyboard
            # events to work
            # But users should be able to choose themselves
            bindKeysScoped: false
              
            # The actual element to bind events to
            bindTo: null
              
            # Hash of bound listeners
            _keyEventBindings: null
              
            # Override delegate events
            delegateEvents: ->
                oldDelegateEvents.apply this, Array::slice.apply(arguments)
                @delegateKeys()
                this

              
            # Clears all callbacks previously bound to the view with `delegateEvents`.
            # You usually don't need to use this, but may wish to if you have multiple
            # Backbone views attached to the same DOM element.
            undelegateEvents: ->
                @undelegateKeys()
                oldUndelegateEvents.apply this, arguments
                this

              
            # Actual delegate keys
            delegateKeys: (keys) ->
                @undelegateKeys()
                @bindTo = (if (@bindKeysScoped or typeof $ is "undefined") then @$el else $(document))  unless @bindTo
                @bindTo.on @bindKeysOn + ".delegateKeys" + @cid, _.bind(@triggerKey, this)
                keys = keys or (@keys)
                if keys
                    _.each keys, ((method, key) ->
                        @keyOn key, method
                    ), this
                this

              
            # Undelegate keys
            undelegateKeys: ->
                @_keyEventBindings = {}
                @bindTo.off @bindKeysOn + ".delegateKeys" + @cid  if @bindTo
                this

              
            # Utility to get the name of a key
            # based on its keyCode
            keyName: (keyCode) ->
                keyName = undefined
                for keyName of BackboneKeysMap
                    return keyName if BackboneKeysMap[keyName] is keyCode
                String.fromCharCode keyCode

              
            # Internal real listener for key events that
            # forwards any relevant key presses
            triggerKey: (e) ->
                key = undefined
                if _.isObject(e)
                    key = e.which
                else if _.isString(e)
                    key = getKeyCode(e)
                else key = e if _.isNumber(e)
                _(@_keyEventBindings[key]).each (listener) ->
                    trigger = true
                    if listener.modifiers
                        trigger = _(listener.modifiers).all((modifier) ->
                            e[modifier + "Key"] is true
                        )
                    listener.method e, listener.key if trigger

                this

              
            # Doing the real work of binding key events
            keyOn: (key, method) ->
                key = key.split(" ")
                if key.length > 1
                    l = key.length
                    @keyOn key[l], method  while l--
                    return
                else
                    key = key.pop().toLowerCase()
                
                # Subtract modifiers
                components = key.split("+")
                key = components.shift()
                keyCode = getKeyCode(key)
                @_keyEventBindings[keyCode] = []  unless @_keyEventBindings.hasOwnProperty(keyCode)
                method = this[method]  unless _.isFunction(method)
                @_keyEventBindings[keyCode].push
                    key: key
                    modifiers: (components or false)
                    method: _.bind(method, this)

                this

            keyOff: (key, method) ->
                method = (method or false)
                if key is null
                    @_keyEventBindings = {}
                    return this
                keyCode = getKeyCode(key)
                method = this[method]  unless _.isFunction(method)
                unless method
                    @_keyEventBindings[keyCode] = []
                    return this
                @_keyEventBindings[keyCode] = _.filter(@_keyEventBindings[keyCode], (data, index) ->
                    data.method is method
                )
                this
            )

    BaseActiveKey
