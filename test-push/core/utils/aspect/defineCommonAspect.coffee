define ["meld", "backbone"], (meld, Backbone) ->
    defineCommonAspect = (method, aspectMethod, aspectBehavior) ->
        asp = meld[aspectBehavior] @, method, @[aspectMethod]
        return asp