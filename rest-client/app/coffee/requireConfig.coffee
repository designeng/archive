require.config

    baseUrl: "/app/js"

    paths:
        # specs
        "bootstrapSpec": "specs/bootstrapSpec"
        "routerMainSpec": "specs/routerMainSpec"

    packages: [
        # lib packages
        {
            name: "wire"
            main: "wire"
            location: "../../bower_components/wire"
        },
        {
            name: "when"
            main: "when"
            location: "../../bower_components/when"
        },
        {
            name: "meld"
            main: "meld"
            location: "../../bower_components/meld"
        },
        {
            name: "cola"
            main: "cola"
            location: "../../bower_components/cola"
        },
        {
            name: "rest"
            main: "rest"
            location: "../../bower_components/rest"
        },
        {
            name: "handlebars"
            main: "handlebars"
            location: "../../bower_components/handlebars"
        },
        {
            name: "hbs"
            main: "hbs"
            location: "../../bower_components/requirejs-hbs"
        },
        {
            name: "crossroads"
            main: "crossroads"
            location: "../../bower_components/crossroads/dist"
        },
        {
            name: "signals"
            main: "signals"
            location: "../../bower_components/signals/dist"
        },
        {
            name: "hasher"
            main: "hasher"
            location: "../../bower_components/hasher/dist/js"
        },
        {
            name: "underscore"
            main: "underscore"
            location: "../../bower_components/underscore"
        },
        {   
            name: "underscore.string"
            main: "underscore.string"
            location: "../../bower_components/underscore.string/lib"
        },
        {
            name: "moment"
            main: "moment"
            location: "../../bower_components/moment"
        },    
        {
            name: "jquery"
            main: "jquery"
            location: "../../bower_components/jquery/dist"
        },        
        {
            name: "text"
            main: "text"
            location: "../../bower_components/text"
        },
        {   
            name: "i18n"
            main: "i18n"
            location: "../../bower_components/requirejs-i18n"
        },
        # requirejs plugins, analog curl plugins
        {
            name: "css"
            main: "css"
            location: "../../bower_components/require-css"
        },
        {
            name: "domReady"
            main: "domReady"
            location: "../../bower_components/requirejs-domready"
        },
        {
            name: "kefir"
            main: "kefir"
            location: "../../bower_components/kefir/dist"
        },
        {
            name: "kefirJquery"
            main: "kefir-jquery"
            location: "../../bower_components/kefir/dist/addons"
        }
    ]

    shim:
        "underscore.string":
            deps: ["underscore"]

    locale: "ru"
    hbs:
        templateExtension: ".html"