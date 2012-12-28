BowShock.GameScreen = class GameScreen extends BowShock.Screen

    collision       : null

    playerSprite    : null

    anim:
        move        : null

    constructor: (name) ->
        super name
        @collision = new BowShock.CollisionManager()
        @

    load: () ->
        @playerSprite = new BowShock.Sprite "textures/move.png",
            tiles: new BowShock.Vector2( 16, 16 )
            scale: new BowShock.Vector2( 80, 80 )
        @playerSprite.load =>
            @playerSprite.setTile 33
            @anim.move = new BowShock.SpriteAnimation @playerSprite, [35..40], 10
            @playerSprite.addToBatch @getSpriteBatch()

        @addEntity 'player', new BowShock.PlayerEntity()
        @addEntity 'floor',  new BowShock.WorldEntity( 100, 500 )

        testCollider    = new BowShock.RectangleCollider 100, 500, BowShock.v2(0, 0),  true
        playerCollider  = new BowShock.RectangleCollider 32,  64,  BowShock.v2(0, 0), true

        @collision.registerCollider testCollider, @getEntity( 'floor' )
        @collision.registerCollider playerCollider, @getEntity( 'player' )

        super()
        @

    update: () ->
        super()
        player = @getEntity 'player'

        if player.isRunning()
            @anim.move.update()
        else if player.isSliding()
            @playerSprite.setTile 41
        else
            @playerSprite.setTile 33

        @playerSprite.flipX() if not player.isFacingRight() and not @playerSprite.flip.x
        @playerSprite.flipX() if     player.isFacingRight() and     @playerSprite.flip.x

        @playerSprite.setPosition player.getPosition()

        @collision.collide player

        @
