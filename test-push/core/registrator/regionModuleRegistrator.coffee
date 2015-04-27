define ->

    class RegionModuleRegistrator
        memoConfig: {}

        constructor: (@ventObject) ->

        registerConfig: (config) ->
            if _.isEmpty @memoConfig
                for region of config
                    @memoConfigPopulate region, config[region]
                _memoConfig = {}
            else 
                _memoConfig = @memoConfig
                @memoConfig = config
            @processRegionConfiguration config, _memoConfig
        
        memoConfigPopulate: (region, modules) ->
            @memoConfig[region] = modules

        processRegionConfiguration: (config, _memoConfig) ->
            pageWorkFlow = {}
            for region of config
                if !_memoConfig[region]
                    a = []
                else
                    a = _memoConfig[region]
                b = config[region]

                zipped = _.zip(a, b)

                if !pageWorkFlow[region]
                    pageWorkFlow[region] = {}

                for part in zipped
                    if part[1] != part[0]                        
                        if !pageWorkFlow[region]["shut"]
                            pageWorkFlow[region]["shut"] = []
                        if !pageWorkFlow[region]["open"]
                            pageWorkFlow[region]["open"] = []
                        pageWorkFlow[region]["shut"].push part[0]
                        pageWorkFlow[region]["open"].push part[1]

            pageWorkFlow



