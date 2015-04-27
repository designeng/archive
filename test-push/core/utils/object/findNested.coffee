define ->
    findNested = (obj, key, memo) ->
        i = undefined
        memo = []  if Object::toString.call(memo) isnt "[object Array]"
        for i of obj
            if Object::hasOwnProperty.call(obj, i)
                if i is key
                    memo.push obj[i]
                else findNested obj[i], key, memo  if Object::toString.call(obj[i]) is "[object Object]"
        memo