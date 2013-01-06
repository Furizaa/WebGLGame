Core.Scene.EditorScene = class EditorScene extends BowShock.Scene

    load: ( doneCallback ) ->
        @loader             = new BowShock.LevelLoader @
        @gui                = new Buzz ".gui"
        @systemController   = @gui.addContainer( "Level" )

        @entityComponents   = [ "Transform", "Input", "Sprite", "Collision", "SpriteAnimation", "PhysicsBody" ]

        # System GUI
        @fileName = @systemController.addController( "Text", "File" ).setValue( "new.json" )
        @systemController.addController( "Button", "Save" ).onClick () => @onSave()
        @systemController.addController( "Button", "Load" ).onClick () => @onLoad()
        @grid = @systemController.addController( "Bar", "Grid" )
        @grid.min( 0 ).max( 64 ).step( 16 ).setValue( 32 )

        # Layers GUI
        @layersController = @gui.addContainer( "Layers" )
        @layersController.addController( "Button", "Create New Layer" ).onClick () =>
            @onAddLayer undefined, prompt( "Layer Name", "LY_UNDEFINED" )
        @layerController = @gui.addContainer( "Layer" )

        @factory         = @getComponentFactory()
        @initLayerLoadCallbacks()
        @reloadScreen()
        super doneCallback

    reloadScreen: () ->
        $('#editor').attr 'width', BowShock.contextWidth
        $('#editor').attr 'height', BowShock.contextHeight
        @context            = document.getElementById('editor').getContext "2d"

    update: ( delta ) ->
        super delta

        if @selected is undefined or @activeLayer is undefined then return

        camPosition = @activeLayer.camera.getPosition()

        transform = @selected.getComponent "TransformComponent"
        position  = transform.getPosition().clone().addSelf camPosition
        size      = transform.getScale()
        @context.strokeStyle = "green"
        @context.strokeRect position.x, position.y , size.x, size.y

    ###
    ENTITY HANDLING
    ###

    onAddEntity: ( layer, newEntity ) ->
        @selected = newEntity
        @onSelectEntity newEntity
        @onAddComponent newEntity.getComponent( "TransformComponent" ), "Transform"

    onSelectEntity: ( entity ) ->
        @onDeselectEntity()
        @entityController = @gui.addContainer( "Entity" )
        @entityController.addController( "Select", "Type" ).options [ "ET_WORLD" ]
        addComponent = @entityController.addController( "Select", "Component+" ).options( @entityComponents )
        addComponent.onChange ( value ) =>
            console.log value + "Component"

    onDeselectEntity: () ->
        @entityController.remove() if @entityController


    onAddComponent: ( component, name ) ->
        @componentController.remove() if @componentController
        @entityController.addController( "Radio", name ).setValue( true )

    ###
    LEVEL HANDLING
    ###

    onSave: () =>
        pojo = 'scene': @factory.saveJson @
        $.post '/level/' + @fileName.value, pojo

    onLoad: () =>
        $.getJSON '/level/' + @fileName.value, ( jsonLevel ) =>
            if not jsonLevel.scene then return
            @layersController.clear "Radio"
            @layerController.clear()
            @loader.load jsonLevel

    ###
    LAYER HANDLING
    ###

    initLayerLoadCallbacks: () ->
        @factory.onLayer = @onAddLayer

    onAddLayer: ( newLayer, name ) =>
        if not name then return
        newLayer   = @layers.addLayer name if not newLayer
        controller = @layersController.addController( "Radio", name )
        if newLayer.isActive()
            controller.setValue true
            @onSelectLayer controller, newLayer
        controller.onChange ( controller, value ) =>
            newLayer.active = value
            @onSelectLayer controller, newLayer if value is true
            @onDeselectLayer controller, newLayer if value is false

    onSelectLayer: ( controller, layer ) ->
        @onDeselectEntity()
        speedX = @layerController.addController( "Bar", "Speed X" ).min( -5 ).max( 5 ).step( 0.1 ).setValue( layer.speed.x )
        speedX.onChange (value) -> layer.speed.x = value
        speedY = @layerController.addController( "Bar", "Speed Y" ).min( -5 ).max( 5 ).step( 0.1 ).setValue( layer.speed.y )
        speedY.onChange (value) -> layer.speed.y = value
        visible = @layerController.addController( "Switch", "Visible" ).setValue( layer.visible )
        visible.onChange (value) -> layer.visible = value
        addEntity = @layerController.addController( "Button", "Create Entity" )
        addEntity.onClick =>
            newEntity = new Core.Entity.WorldEntity()
            @onAddEntity layer, newEntity
        deleteLayer = @layerController.addController( "Button", "Delete Layer")
        deleteLayer.onClick =>
            @onDeselectLayer deleteLayer, layer
            @onDeleteLayer controller, layer
        @activeLayer = layer

    onDeselectLayer: ( controller, layer ) ->
        @layerController.clear()

    onDeleteLayer: ( controller, layer ) ->
        controller.remove()
        @layers.removeLayer layer



