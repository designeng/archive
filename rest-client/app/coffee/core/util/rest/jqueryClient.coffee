define [
    "jquery"
], ($) ->

    class Client

        constructor: (url, data, method, contentType, dataType) ->

            $.ajax({
                type: method
                contentType: contentType || "application/json"
                url: url
                data: data
                dataType: dataType
            })