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

    init: () ->
        super()
        @getRenderer().autoClear = false
        @updateRatio BowShock.contextWidth, BowShock.contextHeight
        @

    updateRatio: ( width, height ) ->
        @width = width
        @height = height
        console.log( "WIDTH: " + @width + " HEIGHT: " + @height ) if BowShock.debug
        @getRenderer().setSize @width, @height

    getRenderer: () ->
        BowShock.Component.RenderComponent.trenderer ?= new THREE.WebGLRenderer()

    getWidth: () ->
        @width

    getHeight: () ->
        @height

    initDom: () ->
        document.body.appendChild @getRenderer().domElement

