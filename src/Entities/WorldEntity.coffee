Core.Entity.WorldEntity = class WorldEntity extends BowShock.Entity

    constructor: () ->
        super()
        transform = @getComponent "TransformComponent"
        transform.setScaleScalar( 32, 32 )

    clone: () ->
        new Core.Entity.WorldEntity()

    getType: () -> "ET_WORLD"
