BowShock.PlayerEntity = class PlayerEntity

    loaded: false

    player:
        position            : new THREE.Vector2 50, 50
        movement            : 0
        maxMoveSpeed        : 7
        moveAcceleration    : 70
        friction            : 0.67
        turnFriction        : 0.48
        velocity            : new THREE.Vector2 0, 0

    animation:
        walk                : null

    constructor: () ->
        @input = BowShock.input
        @animation.walk = new BowShock.SpriteAnimation( [4..7], 10 )
        @

    load: (done) ->
        @loadFinishedCallback = done
        @map = THREE.ImageUtils.loadTexture "textures/move.png", undefined, =>
            @_createPlayerSprite()
            @loaded = true
        @

    update: () ->
        if not @loaded
            return @
        frame = 0

        @player.movement =  1    if @input.isKeyPressed BowShock.Input.KEY_RIGHT
        @player.movement = -1    if @input.isKeyPressed BowShock.Input.KEY_LEFT
        if @player.movement != 0
            @animation.walk.update()
            frame = @animation.walk.getFrame()

        @_applyPhysics()
        @sprite.position.x = Math.round @player.position.x
        @sprite.position.y = Math.round @player.position.y
        @spriteMaterial.uvOffset.set( ((1/16)*(frame+1)), (1-(1/16)*3) )
        @player.movement =  0
        @

    bind: (scene) ->
        scene.add @sprite
        @

    _createPlayerSprite: () ->
        @map.magFilter = THREE.NearestFilter
        @map.minFilter = THREE.LinearMipMapLinearFilter
        @map.flipX = true
        @spriteMaterial = new THREE.SpriteMaterial
            map: @map
            alignment: THREE.SpriteAlignment.topLeft
            useScreenCoordinates: true
        @spriteMaterial.uvScale.set( 1/16, 1/16 )
        @sprite = new THREE.Sprite @spriteMaterial
        @sprite.scale.set 80, 80
        @sprite.opacity = 1
        @sprite.position.normalize()
        @loadFinishedCallback.call @
        @

    _applyPhysics: () ->
        @player.velocity.x += @player.movement * @player.moveAcceleration * BowShock.delta
        @player.velocity.x =  THREE.Math.clamp @player.velocity.x, -@player.maxMoveSpeed, @player.maxMoveSpeed
        @player.velocity.x *= @player.friction if @player.movement == 0
        @player.velocity.x *= @player.turnFriction if @player.movement > 0 and @player.velocity.x < 0
        @player.velocity.x *= @player.turnFriction if @player.movement < 0 and @player.velocity.x > 0
        @player.position.x += @player.velocity.x
        @

