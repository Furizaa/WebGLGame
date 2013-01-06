BowShock.Layer = class Layer extends BowShock.Component.ComponentAssembly

    constructor: () ->
        super()
        @entities  = []
        @scene     = new THREE.Scene()
        @visible   = true
        @active    = false
        @speed     = new BowShock.Vector2( 1, 1 )
        @camera    = @getComponentFactory().buildComponent "Camera", @
        @

    render: ( renderer ) ->
        if @visible
            @_applyCamera( entity, @camera ) for entity in @entities
            renderer.render @scene, @camera.getCamera()
        @

    update: ( delta ) ->
        super delta
        if @active
            entity.update( delta ) for entity in @entities
        @

    reset: () ->
        @disableEntityRender entity for entity in @entities
        @entities = []

    addEntity: ( entity ) ->
        entity.layer = @
        @entities.push entity
        @enableEntityRender entity

    removeEntity: ( entity ) ->
        @disableEntityRender entity
        index = @entities.indexOf entity
        if index != - 1
            @entities[ index ].layer = undefined
            @entities.splice index, 1


    enableEntityRender: ( entity ) ->
        sprite = entity.getComponent( "SpriteComponent" )
        if sprite
            @scene.add sprite.getSprite()
            entity.renderEnabled = true
        entity

    disableEntityRender: ( entity ) ->
        sprite = entity.getComponent( "SpriteComponent" )
        if sprite
            @scene.remove sprite.getSprite()
            entity.renderEnabled = false
        entity

    _applyCamera: ( entity, camera ) ->
        tsprite = entity.getComponent( "SpriteComponent" )?.getSprite()
        position = entity.getComponent( "TransformComponent" ).getPosition()
        if tsprite
            tsprite.position.x = position.x + camera.getPosition().x
            tsprite.position.y = position.y + camera.getPosition().y

    isVisible: () ->
        @visible

    isActive: () ->
        @active

    setActive: ( flag ) ->
        @active = flag

    getCamera: () ->
        @camera

