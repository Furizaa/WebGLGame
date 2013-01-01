BowShock.Camera = class Camera extends BowShock.Vector2

    constructor: (@width, @height) ->
        super 100, 100
        @tcamera = new THREE.CombinedCamera(@width, @height, 45, 1, 10000, -2000, 10000)
        @tcamera.position.z = 1000

    centerOn: (entity) ->
        @x = -entity.getWorldPosition().x + (@width / 2)
        @y = -entity.getWorldPosition().y + (@height / 2)
        BowShock.debug @x, 1
        BowShock.debug @y, 2



