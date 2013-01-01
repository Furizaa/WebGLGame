BowShock.Camera = class Camera extends BowShock.Component.ComponentAssembly

    # We need only one real internal camera
    tcamera = undefined

    constructor: (@width, @height) ->
        @position = new BowShock.Vector2( 0, 0 )
        if not BowShock.Camera.tcamera
            BowShock.Camera.tcamera = new THREE.CombinedCamera(@width, @height, 45, 1, 10000, -2000, 10000)
            BowShock.Camera.tcamera.position.z = 1000

    centerOn: (entity) ->
        @position.x = -entity.getWorldPosition().x + (@width / 2)
        @position.y = -entity.getWorldPosition().y + (@height / 2)

    getPosition: () ->
        @position

    getCamera: () ->
        BowShock.Camera.tcamera


