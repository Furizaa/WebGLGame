BowShock.Component.CameraComponent = class CameraComponent extends BowShock.Component.Component

    # We need only one real internal camera
    @tcamera = undefined

    constructor: () ->
        super()
        @name = "Camera"
        @dependencies = []

    init: () ->
        @position = new BowShock.Vector2 ( BowShock.contextWidth / 2 ), ( BowShock.contextHeight / 2 )
        tcamera = @getCamera()
        if not tcamera
            tcamera = new THREE.CombinedCamera( BowShock.contextWidth, BowShock.contextHeight, 45, 1, 10000, -2000, 10000 )
            tcamera.position.z = 1000
            BowShock.Component.CameraComponent.tcamera = tcamera
        @

    centerOn: (entity) ->
        @position.x = -entity.getWorldPosition().x + ( BowShock.contextWidth / 2 )
        @position.y = -entity.getWorldPosition().y + ( BowShock.contextHeight / 2 )

    getPosition: () ->
        @position

    getCamera: () ->
        BowShock.Component.CameraComponent.tcamera


