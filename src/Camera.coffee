BowShock.Camera = class Camera extends BowShock.Vector2

    constructor: (@width, @height) ->
        super 100, 100

    centerOn: (entity) ->
        @x = -entity.getWorldPosition().x + (@width / 2)
        @y = -entity.getWorldPosition().y + (@height / 2)
        BowShock.debug @x, 1
        BowShock.debug @y, 2



