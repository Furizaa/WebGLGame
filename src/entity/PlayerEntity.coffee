BowShock.PlayerEntity = class PlayerEntity extends BowShock.Entity

    player:
        movement            : 0
        maxMoveSpeed        : 7
        moveAcceleration    : 70
        friction            : 0.87
        turnFriction        : 0.48
        facing              : "right"
        velocity            : new BowShock.Vector2 0, 0
        absVelocity         : new BowShock.Vector2 0, 0

    collider                : null

    animation:
        walk                : null

    constructor: () ->
        super "ET_PLAYER"
        @input = BowShock.input
        @

    init: () ->
        @position.x = 100
        @position.y = 100
        @

    update: () ->
        @player.movement =  1    if @input.isKeyPressed BowShock.Input.KEY_RIGHT
        @player.movement = -1    if @input.isKeyPressed BowShock.Input.KEY_LEFT
        @_applyPhysics()
        @player.facing   =  "right" if @player.movement > 0
        @player.facing   =  "left"  if @player.movement < 0
        @player.movement =  0
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

        @position.x += p.velocity.x
        @

    isRunning: () ->
        @input.isKeyPressed( BowShock.Input.KEY_RIGHT ) or @input.isKeyPressed( BowShock.Input.KEY_LEFT )

    isSliding: () ->
        not @isRunning() and @player.absVelocity.x > 0

    isFacingRight: () ->
        BowShock.debug @player.facing
        @player.facing == "right"

