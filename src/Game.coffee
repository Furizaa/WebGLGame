BowShock.Game = class Game extends BowShock.Component.ComponentAssembly

    constructor: () ->
        super()
        @config   = BowShock.Config.instance()

    init: (width, height) ->
        @renderer = @getComponentFactory().buildComponent "Render", @
        @scenes   = @getComponentFactory().buildComponent "Scene", @
        @input    = @getComponentFactory().buildComponent "Input", @

        @renderer.initDom()


        $('.debugLayer').append "<div class='debug debug1'>debug1</div>"
        $('.debugLayer').append "<div class='debug debug2'>debug2</div>"
        $('.debugLayer').append "<div class='debug debug3'>debug3</div>"
        $('.debugLayer').css
            width:  @renderer.getWidth()
            height: @renderer.getHeight()

        level = new Core.Scene.LevelScene()
        @scenes.activateScene level
        @scenes.resolveSceneChanges()
        @

    update: () ->

        # Update Active Scene
        super()

        # Change Scene
        @scenes.resolveSceneChanges()

    render: () ->
        @scenes.getActiveScene().render @renderer

    onResize: ( event ) ->
        if @renderer
            @renderer.updateRatio BowShock.contextWidth, BowShock.contextHeight