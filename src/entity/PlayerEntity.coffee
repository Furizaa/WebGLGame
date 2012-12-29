BowShock.PlayerEntity = class PlayerEntity extends BowShock.Entity

    player:
        movement            : 0
        maxMoveSpeed        : 7
        moveAcceleration    : 70
        friction            : 0.87
        turnFriction        : 0.45
        gravity             : 25
        maxFallSpeed        : 12
        facing              : "right"
        grounded            : false
        jumpStrength        : 14
        velocity            : new BowShock.Vector2 0, 0
        absVelocity         : new BowShock.Vector2 0, 0

    constructor: (@collisionManager) ->
        super "ET_PLAYER", @collisionManager
        @input = BowShock.input
        @

    init: () ->
        @position.x = 300
        @position.y = 100
        bodyCollider  = new BowShock.RectangleCollider "CT_BODY",  32,  57,  BowShock.v2(-16, -35), true
        feetCollider  = new BowShock.RectangleCollider "CT_FEET",  30,  10,  BowShock.v2(-15,  25),    true
        headCollider  = new BowShock.RectangleCollider "CT_HEAD",  30,  10,  BowShock.v2(-15, -45), true
        @collisionManager.registerCollider bodyCollider, @
        @collisionManager.registerCollider feetCollider, @
        @collisionManager.registerCollider headCollider, @
        @

    update: () ->
        @player.movement =  1    if @input.isKeyPressed BowShock.Input.KEY_RIGHT
        @player.movement = -1    if @input.isKeyPressed BowShock.Input.KEY_LEFT
        if @input.isKeyPressed( BowShock.Input.KEY_UP ) and @player.grounded
            console.log "jump"
            @player.velocity.y = -@player.jumpStrength

        @_applyPhysics()
        @player.facing   =  "right" if @player.movement > 0
        @player.facing   =  "left"  if @player.movement < 0
        @player.movement =  0

        @position.x += @player.velocity.x
        @position.y += @player.velocity.y

        # Handle collision with x Axis
        xCollision = false
        while @collide( "CT_BODY", "CT_WORLD" ) && @player.absVelocity.x > 0
            xCollision = true
            BowShock.debug @player.velocity.x, 3
            @position.x -= BowShock.sign @player.velocity.x, 0.5

        @player.velocity.x = 0 if xCollision

        # Handle Collision with Y Axis
        yCollision = false
        @player.grounded = false
        while @collide( "CT_FEET", "CT_WORLD" ) && @player.velocity.y > 0
            @player.grounded = true
            yCollision = true
            @position.y -= BowShock.sign @player.velocity.y, 0.5

        while @collide( "CT_HEAD", "CT_WORLD" ) && @player.absVelocity.y > 0 && @player.velocity.y < 0
            yCollision = true
            @position.y -= BowShock.sign @player.velocity.y, 0.5

        if yCollision
            @player.velocity.y = 0


        BowShock.debug @player.grounded, 2
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

    isRunning: () ->
        @input.isKeyPressed( BowShock.Input.KEY_RIGHT ) or @input.isKeyPressed( BowShock.Input.KEY_LEFT )

    isSliding: () ->
        not @isRunning() and @player.absVelocity.x > 0

    isFacingRight: () ->
        BowShock.debug @player.facing
        @player.facing == "right"

    isGrounded: () ->
        @player.grounded

    isFalling: () ->
        @player.velocity.y > 0 and not @isGrounded()

    isJumping: () ->
        @player.velocity.y < 0 and not @isGrounded()

