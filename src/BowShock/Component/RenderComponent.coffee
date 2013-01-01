BowShock.Component.RenderComponent = class RenderComponent extends BowShock.Component.Component

    ###
    Internal renderer is static so it can only exists once but the
    component can exist multible times
    ###
    @trenderer = undefined

    constructor: () ->
        super()
        @dependencies = []
        @width  = 800
        @height = 600

    init: ( width, height ) ->
        super()
        @getRenderer().autoClear = false
        @updateRatio width, height if width and height
        @

    updateRatio: ( width, height ) ->
        @width = width
        @height = height
        @getRenderer().setSize @width, @height

    getRenderer: () ->
        BowShock.Component.RenderComponent.trenderer ?= new THREE.WebGLRenderer()

    getWidth: () ->
        @width

    getHeight: () ->
        @height

    initDom: () ->
        document.body.appendChild @getRenderer().domElement

