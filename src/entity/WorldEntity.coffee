BowShock.WorldEntity = class WorldEntity extends BowShock.Entity

    constructor: (@collisionManager, @x, @y, @width, @height) ->
        super "ET_WORLD", @collisionManager
        @

    init: (spriteBatch) ->
        @worldPosition.x = @screenPosition.x = @x
        @worldPosition.y = @screenPosition.y = @y

        collider = new BowShock.RectangleCollider "CT_WORLD", @width, @height, new BowShock.Vector2(0, 0), true
        @collisionManager.registerCollider collider, @

        @sprite = new BowShock.Sprite "textures/testbox2.png",
            scale: new BowShock.Vector2( @width, @height )
        @sprite.load =>
            @sprite.addToBatch spriteBatch
            @loaded = true

        @

    update: () ->
        @sprite.setPosition @getWorldPosition()

