BowShock.Game = class Game extends BowShock.Component.ComponentAssembly

    constructor: () ->
        super()
        @config   = BowShock.Config.instance()
        @clock    = new THREE.Clock()

    init: (width, height) ->
        @renderer = @getComponentFactory().buildComponent "Render", @
        @scenes   = @getComponentFactory().buildComponent "Scene", @
        @input    = @getComponentFactory().buildComponent "Input", @

        @renderer.initDom()

        if BowShock.debug
            $('.debugLayer').append "<div class='debug debug1'>debug1</div>"
            $('.debugLayer').append "<div class='debug debug2'>debug2</div>"
            $('.debugLayer').append "<div class='debug debug3'>debug3</div>"
            $('.debugLayer').css
                width:  @renderer.getWidth()
                height: @renderer.getHeight()
            @stats = new Stats()
            @stats.domElement.style.position = 'absolute'
            @stats.domElement.style.left = '0px'
            @stats.domElement.style.top = '80px'
            document.body.appendChild( @stats.domElement )

        level = new Core.Scene.LevelScene()
        editor = new Core.Scene.EditorScene()

        @scenes.activateScene editor
        @scenes.resolveSceneChanges()
        @

    update: () ->
        @stats.begin()
        # Update Active Scene
        super( @clock.getDelta() )

        # Change Scene
        @scenes.resolveSceneChanges()
        @stats.end()

    render: () ->
        @scenes.getActiveScene().render @renderer

    onResize: ( event ) ->
        if @renderer
            @renderer.updateRatio BowShock.contextWidth, BowShock.contextHeight
            @scenes.getActiveScene()?.reloadScreen()