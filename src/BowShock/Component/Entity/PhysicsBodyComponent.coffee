BowShock.Component.Entity.PhysicsBodyComponent = class PhysicsBodyComponent extends BowShock.Component.Component

    constructor: () ->
        super()
        @dependencies        = [ "CollisionComponent", "TransformComponent" ]
        @maxMoveSpeed        = 3
        @moveAcceleration    = 35
        @friction            = 0.9
        @turnFriction        = 0.45
        @gravity             = 12.5
        @maxFallSpeed        = 6
        @movement            = 0
        @facing              = 1
        @jumpStrength        = 9
        @jumpCourve          = -1
        @grounded            = false
        @velocity            = new BowShock.Vector2 0, 0
        @absVelocity         = new BowShock.Vector2 0, 0
        @

    init: () ->
        super()
        @collision           = @getDependencyComponent( "CollisionComponent" )
        @transform           = @getDependencyComponent( "TransformComponent" )
        @

    applyPhysics: ( delta ) ->

        # Vertical Movement
        @velocity.x += @movement * @moveAcceleration * delta
        @velocity.x =  THREE.Math.clamp @velocity.x, -@maxMoveSpeed, @maxMoveSpeed
        @velocity.x *= @friction if @movement == 0

        # Friction for fast turning
        @velocity.x *= @turnFriction if @movement > 0 and Math.round( @velocity.x ) < 0
        @velocity.x *= @turnFriction if @movement < 0 and Math.round( @velocity.x ) > 0

        # Horizontal Movement
        @velocity.y += @gravity * delta
        @velocity.y =  Math.min @velocity.y, @maxFallSpeed

        # Update Position from Velocities
        @transform.getPosition().x += @velocity.x
        @transform.getPosition().y += @velocity.y

        # Strip velocity for collision detection
        @absVelocity.copy( @velocity )
        @absVelocity.apply( Math.round ).apply( Math.abs )

        # Handle horizontal collision
        if @bodyColliderTag
            xCollision = false
            while @collision.collide( @bodyColliderTag, "CT_WORLD" ) && @absVelocity.x > 0
                xCollision = true
                @transform.getPosition().x -= BowShock.sign @velocity.x, 0.1

            @velocity.x = 0 if xCollision

        # Handle vertical collision in down movement
        @grounded = false
        if @feetColliderTag
            yCollision = false
            while @collision.collide( @feetColliderTag, "CT_WORLD" ) && @velocity.y > 0
                @grounded = true
                yCollision = true
                @transform.getPosition().y -= BowShock.sign @velocity.y, 0.1

        BowShock.debug @grounded, 1

        # Handle vertical collision in up movement
        if @headColliderTag
            while @collision.collide( @headColliderTag, "CT_WORLD" ) && @absVelocity.y > 0 && @velocity.y < 0
                yCollision = true
                @transform.getPosition().y -= BowShock.sign @velocity.y, 0.1

        if yCollision
            @velocity.y = 0

        # Reset movement
        @movement = 0
        @

    doHandleFeetCollision: ( tag ) ->
        @feetColliderTag = tag
        @

    doHandleHeadCollision: ( tag ) ->
        @headColliderTag = tag
        @

    doHandleBodyCollision: ( tag ) ->
        @bodyColliderTag = tag
        @

    jump: () ->
        if @grounded
            @velocity.y = -@jumpStrength

    cancelJump: () ->
        if @isJumping() and not @grounded
            @velocity.y = @jumpCourve

    setMovement: ( @movement ) ->
        @facing = @movement if @movement != 0

    getDirection: () ->
        @facing

    getVelocity: () ->
        @velocity

    isMovingX: () ->
        @absVelocity.x > 0

    isMovingY: () ->
        @absVelocity.y > 0

    isGrounded: () ->
        @grounded

    isFalling: () ->
        @velocity.y > 0 and not @grounded

    isJumping: () ->
        @velocity.y < 0 and not @grounded
