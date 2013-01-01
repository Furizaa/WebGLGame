BowShock.Level = class Level

    data:
        world: [
            { w:50, h:50, x:0, y:200 }
            { w:50, h:50, x:50, y:200 }
            { w:50, h:50, x:100, y:200 }
            { w:50, h:50, x:150, y:200 }
            { w:50, h:50, x:200, y:200 }
            { w:50, h:50, x:250, y:200 }
            { w:50, h:50, x:300, y:200 }
            { w:50, h:50, x:350, y:200 }
            { w:50, h:50, x:400, y:200 }
            { w:50, h:50, x:450, y:200 }
            { w:50, h:50, x:500, y:200 }
            { w:50, h:50, x:550, y:200 }
            { w:50, h:50, x:600, y:200 }
            { w:50, h:50, x:650, y:200 }
            { w:50, h:50, x:700, y:200 }
            { w:50, h:50, x:750, y:200 }
        ]

    constructor: (@screen) ->

    generate: () ->
        for tile in @data.world
            entity = new BowShock.WorldEntity @screen.getCollisionManager(), tile.x, tile.y, tile.w, tile.h
            @screen.addEntity "WORLD" + @screen.getEntityCount(), entity
