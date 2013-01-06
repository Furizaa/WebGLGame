BowShock.Component.Entity.TransformComponent = class TransformComponent extends BowShock.Component.EntityComponent

    constructor: () ->
        @dependencies = []
        @position = new BowShock.Vector2 0, 0
        @scale    = new BowShock.Vector2 0, 0
        @rotation = 0

    getPosition: () ->
        @position

    setPosition: ( vector2 ) ->
        @setPositionScalar vector2.x, vector2.y

    setPositionScalar: ( x, y ) ->
        @position.x = x
        @position.y = y

    normalizePosition: () ->
        @position.x = Math.round @position.x
        @position.y = Math.round @position.y

    getScale: () ->
        @scale

    setScale: ( vector2 ) ->
        @setScaleScalar vector2.x, vector2.y

    setScaleScalar: ( x, y ) ->
        @scale.x = x
        @scale.y = y

    getRotation: () ->
        @rotation

    setRotaion: ( rotation ) ->
        @rotation = rotation

    getProjected: ( camera ) ->
        @position.clone().addSelf camera.getPosition()

    clone: ( parentAssembly, doneCallback ) ->
        console.log "CLONE TRANSFORM"
        clone = new BowShock.Component.Entity.TransformComponent()
        clone.position  = @position.clone()
        clone.scale     = @scale.clone()
        clone.rotation  = @rotation
        doneCallback?.call @, clone, "TransformComponent"



