Core.Entity.WorldEntity = class WorldEntity extends BowShock.Entity

    constructor: () ->
        super()
        @transform.setScaleScalar( 32, 32 )

    getType: () -> "ET_WORLD"
