Core.Entity.PlayerEntity = class PlayerEntity extends BowShock.Component.ComponentAssembly

    player:
        movement            : 0
        maxMoveSpeed        : 6
        moveAcceleration    : 70
        friction            : 0.87
        turnFriction        : 0.45
        gravity             : 25
        maxFallSpeed        : 12
        facing              : "right"
        grounded            : false
        jumpStrength        : 14
        jumpCourve          : -1
        velocity            : new BowShock.Vector2 0, 0
        absVelocity         : new BowShock.Vector2 0, 0

    constructor: () ->
        super()
        @input = BowShock.input
        @anim  = {}
        @

    load: ( doneCallback ) ->
        @transform  = @getComponentFactory().buildComponent "Transform", @
        @input      = @getComponentFactory().buildComponent "Input", @
        @collision  = @getComponentFactory().buildComponent "Collision", @
        @sprite     = @getComponentFactory().buildComponent "Sprite", @
        @sprite.loadFile "textures/move.png", 16, 16, =>
            @playerSprite.setTile 33
            @anim.move  = new BowShock.SpriteAnimation @playerSprite, [35..40], 10, true
            @anim.stand = new BowShock.SpriteAnimation @playerSprite, [33], 1, false
            @anim.slide = new BowShock.SpriteAnimation @playerSprite, [41, 42], 3, false
            @anim.jump  = new BowShock.SpriteAnimation @playerSprite, [119], 1, false
            @anim.fall  = new BowShock.SpriteAnimation @playerSprite, [120], 1, false
            doneCallback.call @

        @transform.setPositionScalar 100, 100

        bodyCollider  = new BowShock.Collider.RectangleCollider "CT_BODY",  32,  55,  BowShock.v2(0, 0), true
        feetCollider  = new BowShock.Collider.RectangleCollider "CT_FEET",  30,  10,  BowShock.v2(0, 34),    true
        headCollider  = new BowShock.Collider.RectangleCollider "CT_HEAD",  30,  10,  BowShock.v2(0, -35), true
        @collision.registerCollider bodyCollider, @
        @collision.registerCollider feetCollider, @
        @collision.registerCollider headCollider, @
        @

    update: ( delta ) ->
        @player.movement =  1    if @input.isKeyHeld BowShock.KEY_RIGHT
        @player.movement = -1    if @input.isKeyHeld BowShock.KEY_LEFT

        if @input.isKeyPressed( BowShock.KEY_UP ) and @player.grounded
            @player.velocity.y = -@player.jumpStrength
        if @input.isKeyReleased( BowShock.KEY_UP ) and not @player.grounded and not @isFalling()
            @player.velocity.y = @player.jumpCourve

        @_applyPhysics()
        @player.facing   =  "right" if @player.movement > 0
        @player.facing   =  "left"  if @player.movement < 0
        @player.movement =  0

        @transform.getPosition().x += @player.velocity.x
        @transform.getPosition().y += @player.velocity.y

        # Handle collision with x Axis
        xCollision = false
        while @collision.collide( "CT_BODY", "CT_WORLD" ) && @player.absVelocity.x > 0
            xCollision = true
            @transform.getPosition().x -= BowShock.sign @player.velocity.x, 0.5

        @player.velocity.x = 0 if xCollision

        # Handle Collision with Y Axis
        yCollision = false
        @player.grounded = false
        while @collision.collide( "CT_FEET", "CT_WORLD" ) && @player.velocity.y > 0
            @player.grounded = true
            yCollision = true
            @transform.getPosition().y -= BowShock.sign @player.velocity.y, 0.5

        while @collision.collide( "CT_HEAD", "CT_WORLD" ) && @player.absVelocity.y > 0 && @player.velocity.y < 0
            yCollision = true
            @transform.getPosition().y -= BowShock.sign @player.velocity.y, 0.5

        if yCollision
            @player.velocity.y = 0

        @transform.normalizePosition()
        @_updateSprite()
        @

    _applyPhysics: () ->
        p = @player
        p.velocity.x += p.movement * p.moveAcceleration * BowShock.delta
        p.velocity.x =  THREE.Math.clamp p.velocity.x, -p.maxMoveSpeed, p.maxMoveSpeed
        p.velocity.x *= p.friction if p.movement == 0

        #Strip velocity for animation
        p.absVelocity.copy( p.velocity )
        p.absVelocity.apply( Math.round ).apply( Math.abs )

        p.velocity.x *= p.turnFriction if p.movement > 0 and Math.round( p.velocity.x ) < 0
        p.velocity.x *= p.turnFriction if p.movement < 0 and Math.round( p.velocity.x ) > 0

        p.velocity.y += p.gravity * BowShock.delta
        p.velocity.y =  Math.min p.velocity.y, p.maxFallSpeed
        @

    _updateSprite: () ->
        if @isGrounded()
            if @isRunning()
                @anim.move.play()
            else if @isSliding()
                @anim.slide.play()
            else
                @anim.stand.play()
        else
            if @isJumping()
                @anim.jump.play()
            if @isFalling()
                @anim.fall.play()

        @sprite.flipX() if not @isFacingRight() and not @sprite.flip.x
        @sprite.flipX() if     @isFacingRight() and     @sprite.flip.x

        #BowShock.spriteCam.centerOn @
        @sprite.setPosition @transform.getPosition()

    isRunning: () ->
        @input.isKeyHeld( BowShock.KEY_RIGHT ) or @input.isKeyHeld( BowShock.KEY_LEFT )

    isSliding: () ->
        not @isRunning() and @player.absVelocity.x > 0

    isFacingRight: () ->
        @player.facing == "right"

    isGrounded: () ->
        @player.grounded

    isFalling: () ->
        @player.velocity.y > 0 and not @isGrounded()

    isJumping: () ->
        @player.velocity.y < 0 and not @isGrounded()

