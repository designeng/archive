define ["underscore"
        "backbone"
        "marionette"
], (_, Backbone, Marionette) ->

        classHash = {}

        resolveClass = (name, callback) ->
            if _.isFunction(name)
                return callback(name)
            else if _.isString(name)
                parts = undefined
                i = undefined
                len = undefined
                obj = undefined
                parts = name.split(".")
                i = 0
                len = parts.length
                obj = window

                while i < len
                    obj = obj[parts[i]]
                    ++i
                if obj
                    return callback(obj)
                else
                    return require([name], callback)  if typeof require isnt "undefined"
            throw new Error("Cannot resolve class \"" + name + "\"")

        resolveClassInstance = (classObject, options) ->
            instance = new classObject(options)
            return instance

        resolve = (classType, resolve, reject, callback) ->
            try
                resultClass = require classType
                resolve(classType)
                callback(classType)
            catch e
                if e.requireType is "notloaded"
                    require [classType], (classTypeView) =>

                        resolve(classType)
                        callback(classTypeView)

        # alias?
        resolveControl = resolveClass
        resolveControlInstance = resolveClassInstance


        return resolver = {
            classHash: classHash
            resolveClass: resolveClass
            resolveClassInstance: resolveClassInstance
            resolveControl: resolveControl
            resolveControlInstance: resolveControlInstance
            resolve: resolve
        }


