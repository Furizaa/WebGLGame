BowShock.Level = class Level

    data:
        world: [
            { w:500, h:50, x:0, y:200 },
            { w:500, h:50, x:250, y:200 }
        ]

    constructor: (@screen) ->

    generate: () ->
        for tile in @data.world
            entity = new BowShock.WorldEntity @screen.getCollisionManager(), tile.x, tile.y, tile.w, tile.h
            @screen.addEntity "WORLD" + @screen.getEntityCount(), entity
