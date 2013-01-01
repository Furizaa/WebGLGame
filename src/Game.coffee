BowShock.Game = class Game

    constructor: () ->
        @config   = BowShock.Config.instance()
        @assembly = new BowShock.Component.ComponentAssembly()

    init: (width, height) ->
        @renderer = @assembly.addComponent( "Render" ).init( window.innerWidth, window.innerHeight )
        @scenes   = @assembly.addComponent( "Scene"  ).init()
        @input    = @assembly.addComponent( "Input"  ).init()

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

    run: () ->
        @update()
        @render()

    update: () ->
        @scenes.getActiveScene().update()
        @scenes.resolveSceneChanges()

    render: () ->
        @scenes.getActiveScene().render()

    onResize: ( event ) ->
        if @renderer
            @renderer.updateRatio window.innerWidth, window.innerHeight