BowShock.Vector2 = class Vector2 extends THREE.Vector2

    apply: (callback) ->
        @x = callback.call @, @.x
        @y = callback.call @, @.y
        @