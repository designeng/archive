define
    $plugins:[
        "wire/debug"
        "wire/dom"
        "wire/dom/render"
        "wire/on"
        "core/plugin/template/hb"
    ]

    controller:
        create: "components/client/controller"
        ready:
            onReady: {}
        properties:
            form: {$ref: 'form'}
            config: {$ref: 'config'}

    config:
        module: "text!config.json"

    formPattern:
        module: "hbs!components/client/template"

    formTemplate:
        templateSource:
            pattern: {$ref: 'formPattern'}
            fillWith:
                packResponseService : "packResponseService"
                paymentService      : "paymentService"
                clear               : "clear"

    form:
        render:
            template: {$ref: 'formTemplate'}
        insert:
            at: {$ref: 'slot'}
        on:
            "click:.packResponseService": "controller.onCallPackResponseService"
            "click:.paymentService": "controller.onCallPaymentService"