BowShock.Layer = class Layer

    constructor: ( @camera ) ->
        @entities  = []
        @scene     = new THREE.Scene()
        @visible   = true
        @active    = false
        @

    render: ( renderer ) ->
        if @visible
            @_applyCamera( entity, @camera ) for entity in @entities
            renderer.render @scene, @camera.getCamera()
        @

    update: ( delta ) ->
        if @active
            entity.update( delta ) for entity in @entities
        @

    addEntity: ( entity ) ->
        @entities.push entity
        sprite = entity.getComponent( "Sprite" )
        @scene.add sprite.getSprite() if sprite
        entity

    _applyCamera: ( entity, camera ) ->
        tsprite = entity.getComponent( "Sprite" )?.getSprite()
        position = entity.getComponent( "Transform" ).getPosition()
        if tsprite
            tsprite.position.x = position.x + camera.getPosition().x
            tsprite.position.y = position.y + camera.getPosition().y

    isVisible: () ->
        @visible

    isActive: () ->
        @active

    setActive: ( flag ) ->
        @active = flag

