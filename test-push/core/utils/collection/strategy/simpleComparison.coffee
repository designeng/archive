define ->
    simpleComparison =

        sortDirection: -1

        sortByAttr: (attr, sortDirection) ->
            @sortAttribute = attr
            @sortDirection = sortDirection
            @sort()

        comparator: (a, b) ->
            a = a.get(@sortAttribute)
            b = b.get(@sortAttribute)
            return 0  if a is b
            if @sortDirection is 1
                (if a > b then 1 else -1)
            else
                (if a < b then 1 else -1)

