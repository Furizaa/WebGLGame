BowShock.WorldEntity = class WorldEntity extends BowShock.Entity

    constructor: (@collisionManager, @width, @height) ->
        super "ET_WORLD", @collisionManager
        @

    init: () ->
        testCollider1 = new BowShock.RectangleCollider "CT_WORLD", 20, 600, BowShock.v2(50, 0),  true
        testCollider2 = new BowShock.RectangleCollider "CT_WORLD", 50, 15, BowShock.v2(500, 539),  true
        testCollider3 = new BowShock.RectangleCollider "CT_WORLD", 200, 30, BowShock.v2(450, 350),  true


        floor = new BowShock.RectangleCollider "CT_WORLD", 1200, 50, BowShock.v2(0, 550),  true

        @collisionManager.registerCollider testCollider1, @
        @collisionManager.registerCollider testCollider2, @
        @collisionManager.registerCollider testCollider3, @
        @collisionManager.registerCollider floor, @
        @

