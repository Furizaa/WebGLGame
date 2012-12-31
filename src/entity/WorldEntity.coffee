BowShock.WorldEntity = class WorldEntity extends BowShock.Entity

    constructor: (@collisionManager, @x, @y, @width, @height) ->
        super "ET_WORLD", @collisionManager
        @

    init: () ->
        @worldPosition.x = @x
        @worldPosition.y = @y
        console.log @
        collider = new BowShock.RectangleCollider "CT_WORLD", @width, @height, @worldPosition, true
        @collisionManager.registerCollider collider, @
        @

