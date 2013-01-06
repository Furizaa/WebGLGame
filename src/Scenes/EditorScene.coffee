Core.Scene.EditorScene = class EditorScene extends BowShock.Scene

    load: ( doneCallback ) ->
        @loader             = new BowShock.LevelLoader @
        @gui                = new Buzz ".gui"
        @systemController   = @gui.addContainer( "Level" )

        @entityComponents   = [ "TransformComponent", "InputComponent", "SpriteComponent", "CollisionComponent", "SpriteAnimationComponent", "PhysicsBodyComponent" ]

        # System GUI
        @fileName = @systemController.addController( "Text", "File" ).setValue( "new.json" )
        @systemController.addController( "Button", "Save" ).onClick () => @onSave()
        @systemController.addController( "Button", "Load" ).onClick () => @onLoad()
        @grid = @systemController.addController( "Bar", "Grid" )
        @grid.min( 0 ).max( 64 ).step( 16 ).setValue( 32 )
        @collisionVisible = @systemController.addController( "Switch", "Display Colliders")

        # Layers GUI
        @layersController = @gui.addContainer( "Layers" )
        @layersController.addController( "Button", "Create New Layer" ).onClick () =>
            @onAddLayer undefined, prompt( "Layer Name", "LY_UNDEFINED" )
        @layerController = @gui.addContainer( "Layer" )

        @factory         = @getComponentFactory()
        @canvas          = document.getElementById('editor')
        @mouse           = new BowShock.Vector2( 0, 0 )
        @$canvas         = $( @canvas )
        @$window         = $( window )
        @$canvas.on 'mousemove', ( event ) =>
            @mouse.x = event.offsetX
            @mouse.y = event.offsetY
        @$canvas.on 'mousedown', ( event ) =>
            if @selected && not @hovered
                @$window.on 'mousemove', => @click( event )
                @$window.on 'mouseup', =>
                    @$window.off 'mouseup mousemove'
            if @selected && @hovered && @selected == @hovered
                @$window.on 'mousemove', => @move()
                @$window.on 'mouseup', =>
                    @$window.off 'mouseup mousemove'
        @$canvas.on 'click', ( event ) => @click( event )


        @initLoadCallbacks()
        @reloadScreen()
        super doneCallback


    reloadScreen: () ->
        $('#editor').attr 'width', BowShock.contextWidth
        $('#editor').attr 'height', BowShock.contextHeight
        @context = @canvas.getContext "2d"

    initLoadCallbacks: () ->
        @factory.onLayer = @onAddLayer
        @factory.onEntity = @onAddEntity
        @factory.onSprite = @onLoadedSprite

    update: ( delta ) ->
        super delta
        @context.clearRect 0, 0, BowShock.contextWidth, BowShock.contextHeight

        if @activeLayer is undefined then return

        if @collisionVisible.value is true
            for entity in @activeLayer.entities
                collisionComponent = entity.getComponent "CollisionComponent"
                if collisionComponent
                    for collider in collisionComponent.localColliders
                        position = collider.getEntity().getComponent( "TransformComponent" ).getProjected @activeLayer.camera
                        @context.strokeStyle = "blue"
                        @context.strokeRect position.x - (collider.width / 2), position.y - (collider.height / 2), collider.width, collider.height


        @hovered = @pickEntity @mouse

        if @selected
            @wrapEntity @selected, "green"
            transform  = @selected.getComponent "TransformComponent"
            if not @hovered
                cursor = @mouse.clone()
                cursor.x -= cursor.x % @grid.value
                cursor.y -= cursor.y % @grid.value
                @context.strokeStyle = "white"
                @context.strokeRect cursor.x, cursor.y, transform.getScale().x, transform.getScale().y
                @hovered = undefined

        if @hovered then @wrapEntity @hovered, "red"



    pickEntity: ( picpos ) ->
        for entity in @activeLayer.entities
            transform   = entity.getComponent "TransformComponent"
            position    = transform.getProjected @activeLayer.camera
            scale = transform.getScale()
            position.x -= scale.x / 2
            position.y -= scale.y / 2
            if picpos.x >= position.x && picpos.x <= (position.x + scale.x) && picpos.y >= position.y && picpos.y <= (position.y + scale.y)
                return entity

    wrapEntity: ( entity, color ) ->
        transform = entity.getComponent "TransformComponent"
        position  = transform.getProjected @activeLayer.camera
        size      = transform.getScale()
        @context.strokeStyle = color
        @context.strokeRect position.x - (size.x / 2), position.y - (size.y / 2), size.x, size.y
        @context.beginPath()
        @context.moveTo position.x - (size.x / 2), position.y - (size.y / 2)
        @context.lineTo position.x - (size.x / 2) + size.x, position.y - (size.y / 2) + size.y
        @context.stroke()
        @

    click: ( event ) ->
        cursor = @mouse.clone()
        cursor.x -= cursor.x % @grid.value
        cursor.y -= cursor.y % @grid.value
        if @selected && !@hovered && not event.altKey
            @factory.clone @selected, ( clone ) =>
                @activeLayer.addEntity clone
                @activeLayer.enableEntityRender clone
                transform = clone.getComponent "TransformComponent"
                transform.getPosition().x = cursor.x - @activeLayer.camera.position.x + transform.getScale().x / 2
                transform.getPosition().y = cursor.y - @activeLayer.camera.position.y + transform.getScale().y / 2
        if @hovered && event.altKey
            @activeLayer.removeEntity @hovered
            @onDeselectEntity() if @hovered == @selected
            @hovered = undefined
        if @hovered && !event.altKey
            @onSelectEntity @hovered


    move: () ->
        cursor = @mouse.clone()
        cursor.x -= cursor.x % @grid.value
        cursor.y -= cursor.y % @grid.value
        transform = @selected.getComponent "TransformComponent"
        transform.getPosition().x = cursor.x - @activeLayer.camera.position.x + transform.getScale().x / 2
        transform.getPosition().y = cursor.y - @activeLayer.camera.position.y + transform.getScale().y / 2


    ###
    COMPONENT HANDLING
    ###

    onAddTransformComponent: ( component ) ->
        posx   = @componentController.addController( "Number", "Pos X" ).setValue( component.getPosition().x )
        posy   = @componentController.addController( "Number", "Pos Y" ).setValue( component.getPosition().y )
        scalex = @componentController.addController( "Number", "Scale X" ).setValue( component.getScale().x )
        scaley = @componentController.addController( "Number", "Scale Y" ).setValue( component.getScale().y )

        posx.onChange ( value ) -> component.getPosition().x = value
        posy.onChange ( value ) -> component.getPosition().y = value
        scalex.onChange ( value ) -> component.getScale().x = value
        scaley.onChange ( value ) -> component.getScale().y = value

    onAddSpriteComponent: ( component ) ->
        file = @componentController.addController( "Text", "Image" ).setValue( component.fileName || "textures/" )
        tilesx = @componentController.addController( "Number", "TilesUV H" ).min(0).max(32).setValue( component.tilesX )
        tilesy = @componentController.addController( "Number", "TilesUV V" ).min(0).max(32).setValue( component.tilesY )
        tile   = @componentController.addController( "Bar", "Tile" ).min(0).max(16*16).setValue( component.tile )
        file.onChange (value) =>
            @activeLayer.disableEntityRender @selected
            component.loadFile file.value, tilesx.value, tilesy.value, =>
                @activeLayer.enableEntityRender @selected
        tilesx.onChange (value) => component.setTiles value, tilesy.value
        tilesy.onChange (value) => component.setTiles tilesx.value, value
        tile.onChange (value) => component.setTile value

    onAddCollisionComponent: ( component ) ->
        button = @componentController.addController( "Button", "Add Collider" )
        button.onClick =>
            newCollider = new BowShock.Collider.RectangleCollider( "CT_WORLD", 32, 32, new BowShock.Vector2( 0, 0 ), true )
            component.registerCollider newCollider
            @onAddCollider component, newCollider
        for collider in component.localColliders
            @onAddCollider component, collider


    ###
    ColliderHandling
    ###

    onAddCollider: ( colliderComponent, collider ) ->
        entry = @componentController.addController( "Radio", "Rectangle Collider" )
        entry.onChange ( controller, value ) =>
            @onSelectCollider collider if value is true

    onSelectCollider: ( collider ) ->
        console.log collider
        @colliderController.remove() if @colliderController
        @colliderController = @gui.addContainer( "RectangleCollider" )
        tag = @colliderController.addController( "Select", "Tag").options [ "CT_WORLD" ]
        tag.setValue collider.tag
        width = @colliderController.addController( "Bar", "Width" ).min(0).max(500).setValue collider.width
        width.onChange ( value ) =>
            collider.width = value
        height = @colliderController.addController( "Bar", "Height" ).min(0).max(500).setValue collider.height
        height.onChange ( value ) =>
            collider.height = value


    ###
    SPRITE HANDLING
    ###

    onLoadedSprite: ( sprite ) ->
        entity = sprite.parentAssembly
        entity.layer.enableEntityRender entity

    ###
    ENTITY HANDLING
    ###

    onAddEntity: ( layer, newEntity ) =>
        @onSelectEntity newEntity if not @selected


    onSelectEntity: ( entity ) ->
        @onDeselectEntity() if @selected
        @selected = entity
        @entityController = @gui.addContainer( "Entity" )
        @entityController.addController( "Select", "Type" ).options [ "ET_WORLD" ]
        addComponent = @entityController.addController( "Select", "Component+" ).options( @entityComponents )
        addComponent.onChange ( value ) =>
            if not entity.getComponent( value )
                component = @factory.buildComponent value, entity, @onAddComponent
                @onAddComponent component, value
        @onAddComponent comp, name for name, comp of entity.getComponentList()


    onDeselectEntity: () ->
        @entityController.remove() if @entityController
        @selected = undefined


    onAddComponent: ( component, name ) =>
        @entityController.addController( "Radio", name ).onChange ( value ) =>
            @onSelectComponent component, name


    onSelectComponent: ( component, name ) ->
        @colliderController.remove() if @colliderController
        @componentController.remove() if @componentController
        @componentController = @gui.addContainer( name )
        @[ 'onAdd' + name ]?.call @, component


    ###
    LEVEL HANDLING
    ###

    onSave: () =>
        pojo = 'scene': @factory.saveJson @
        $.post '/level/' + @fileName.value, pojo

    onLoad: () =>
        @layers.reset()
        @componentController?.remove()
        @entityController?.remove()
        $.getJSON '/level/' + @fileName.value, ( jsonLevel ) =>
            if not jsonLevel.scene then return
            @layersController.clear "Radio"
            @layerController.clear()
            @loader.load jsonLevel

    ###
    LAYER HANDLING
    ###

    onAddLayer: ( newLayer, name ) =>
        if not name then return
        newLayer   = @layers.addLayer name if not newLayer
        newLayer.active = true
        controller = @layersController.addController( "Radio", name )
        if newLayer.isActive()
            controller.setValue true
            @onSelectLayer controller, newLayer
        controller.onChange ( controller, value ) =>
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
            layer.addEntity newEntity
            @onAddEntity layer, newEntity
            @onSelectEntity newEntity
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



