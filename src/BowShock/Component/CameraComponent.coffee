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
            tcamera = new THREE.PerspectiveCamera( 40, BowShock.contextWidth / BowShock.contextHeight, 1, 5000 )
            tcamera.position.z = 1000
            BowShock.Component.CameraComponent.tcamera = tcamera
        @

    centerOn: ( entity ) ->
        @entityTransform ?= entity.getComponent "Transform"
        @position.x = -@entityTransform.getPosition().x + ( BowShock.contextWidth / 2 )
        @position.y = -@entityTransform.getPosition().y + ( BowShock.contextHeight / 2 )

    getPosition: () ->
        @position

    getCamera: () ->
        BowShock.Component.CameraComponent.tcamera


