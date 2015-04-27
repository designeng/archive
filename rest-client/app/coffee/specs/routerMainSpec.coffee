# routerMainSpec
define
    $plugins: [
        # "wire/debug"
        "wire/dom"
        "core/plugin/contextRouter"
    ]

    appRouter:
        contextRouter: 
            routes:
                "client"    :
                    spec: "components/client/spec"
                    slot: {$ref: "dom.first!#page"}

