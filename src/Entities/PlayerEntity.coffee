Core.Entity.PlayerEntity = class PlayerEntity extends BowShock.Component.ComponentAssembly

    getType: () -> "ET_PLAYER"

    load: ( doneCallback ) ->
        @transform  = @getComponentFactory().buildComponent( "Transform", @ )
        @input      = @getComponentFactory().buildComponent( "Input", @ )
        @collision  = @getComponentFactory().buildComponent( "Collision", @ )
        @sprite     = @getComponentFactory().buildComponent( "Sprite", @ )
        @animation  = @getComponentFactory().buildComponent( "SpriteAnimation", @ )
        @physics    = @getComponentFactory().buildComponent( "PhysicsBody", @ )
        @sprite.loadFile "textures/move.png", 16, 16, =>
            @animation.addAnimation "move",  [35..40], 5, true
            @animation.addAnimation "stand", [33],     1
            @animation.addAnimation "slide", [41, 42], 1.5
            @animation.addAnimation "jump",  [119],    1
            @animation.addAnimation "fall",  [120],    1
            doneCallback.call @, @

        @transform.setPositionScalar 0, -300
        @transform.setScaleScalar 80, 80

        bodyCollider  = new BowShock.Collider.RectangleCollider "CT_BODY",  32,  55,  BowShock.v2(0, 0), true
        feetCollider  = new BowShock.Collider.RectangleCollider "CT_FEET",  30,  10,  BowShock.v2(0, 34),    true
        headCollider  = new BowShock.Collider.RectangleCollider "CT_HEAD",  30,  10,  BowShock.v2(0, -35), true
        @collision.registerCollider bodyCollider, @
        @collision.registerCollider feetCollider, @
        @collision.registerCollider headCollider, @

        @physics.doHandleHeadCollision "CT_HEAD"
        @physics.doHandleFeetCollision "CT_FEET"
        @physics.doHandleBodyCollision "CT_BODY"
        @

    update: ( delta ) ->
        super delta
        @physics.setMovement 1  if @input.isKeyHeld         BowShock.KEY_RIGHT
        @physics.setMovement -1 if @input.isKeyHeld         BowShock.KEY_LEFT
        @physics.jump()         if @input.isKeyPressed      BowShock.KEY_UP
        @physics.cancelJump()   if @input.isKeyReleased     BowShock.KEY_UP

        @physics.applyPhysics( delta )

        @transform.normalizePosition()

        if @physics.isGrounded()
            if @isRunning()
                @animation.play( "move", delta )
            else if @isSliding()
                @animation.play( "slide", delta )
            else
                @animation.play( "stand", delta )
        else
            if @physics.isJumping()
                @animation.play( "jump", delta )
            if @physics.isFalling()
                @animation.play( "fall", delta )

        @sprite.flipX() if not @isFacingRight() and not @sprite.flip.x
        @sprite.flipX() if     @isFacingRight() and     @sprite.flip.x
        @

    isFacingRight: () ->
        @physics.getDirection() is 1

    isRunning: () ->
        if @input.isKeyHeld( BowShock.KEY_RIGHT ) || @input.isKeyHeld( BowShock.KEY_LEFT )
            return true
        false

    isSliding: () ->
        not @isRunning() and @physics.absVelocity.x > 0



