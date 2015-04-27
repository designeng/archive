define [
    "underscore"
    "jquery"
    "when"
    "core/util/rest/client"
    "core/util/rest/jqueryClient"
], (_, $, When, Client, JqueryClient) ->

    class Controller

        # @injected
        form: null
        # @injected
        config: null

        onReady: ->
            @config = JSON.parse @config
            @baseServiceUrl = @config.serviceUrlHost + @config.serviceUrl + @config.apiVersion

            @serviceMap =
                packResponseService:
                    path: @baseServiceUrl + "/packs/{cpid}"
                    method: "GET"
                paymentService:
                    path: @baseServiceUrl + "/packs/{cpid}/invoices/{invoiceId}/pricings/{paymentMethodId}/paymentLink"
                    method: "PUT"
                    data:
                        "successCallbackUrl"    : "...successCallbackUrl"
                        "failCallbackUrl"       : "...failCallbackUrl"

            @cpidInput = $(@form).find(".cpid")
            @paymentServiceInput = $(@form).find(".paymentService")

            @cpidInput.on "keyup change", () =>
                @paymentServiceInput.hide()

            @client = new Client("mime", "entity")

        onCallPackResponseService: ->
            cpid = @cpidInput.val()
            path = @patchPath(@serviceMap["packResponseService"].path, {cpid: cpid})
            method = @serviceMap["packResponseService"].method

            @client({ 
                path: path
                data: {}
                method: method
            }).then (res) =>
                console.log "packResponseService RES:::::", res
                @paymentServiceInput.show()
                @response = res
            .otherwise (error) ->
                console.log "ERROR::::", error

        onCallPaymentService: ->
            cpid = @cpidInput.val()
            path = @patchPath(@serviceMap["paymentService"].path, {
                cpid            : cpid
                invoiceId       : @getInvoiceId()
                paymentMethodId   : @getPaymentMethodId()
            })
            method = @serviceMap["paymentService"].method
            data = @serviceMap["paymentService"].data

            @client({ 
                path: path
                data: JSON.stringify(data)
                method: method
            }).then (res) =>
                console.log "paymentService RES:::::", res
            .otherwise (error) ->
                console.log "ERROR::::", error

            # (url, data, method, contentType, dataType)

            # new JqueryClient(path, JSON.stringify(data), method, "application/json")

        getInvoiceId: ->
            @response.data.invoices[0].id

        getPaymentMethodId: ->
            @response.data.invoices[0].pricings[0].paymentMethod.id

        patchPath: (path, data) ->
            return _.reduce data, (result, value, key) ->
                result.replace("{#{key}}", value)
            , path