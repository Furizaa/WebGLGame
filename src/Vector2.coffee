BowShock.Vector2 = class Vector2 extends THREE.Vector2

    @zero: () ->
        new BowShock.Vector2(0, 0)

    apply: (callback) ->
        @x = callback.call @, @.x
        @y = callback.call @, @.y
        @

    clone: () ->
        new BowShock.Vector2 @x, @y