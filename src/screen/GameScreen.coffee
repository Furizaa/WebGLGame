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

        @addEntity 'player', new BowShock.PlayerEntity( @collision )
        @addEntity 'floor',  new BowShock.WorldEntity( @collision, 0, 0 )

        super()
        @

    update: () ->
        super()
        player = @getEntity 'player'

        if player.isGrounded()
            if player.isRunning()
                @anim.move.update()
            else if player.isSliding()
                @playerSprite.setTile 41
            else
                @playerSprite.setTile 33
        else
            if player.isJumping()
                @playerSprite.setTile 119
            if player.isFalling()
                @playerSprite.setTile 120

        @playerSprite.flipX() if not player.isFacingRight() and not @playerSprite.flip.x
        @playerSprite.flipX() if     player.isFacingRight() and     @playerSprite.flip.x

        @playerSprite.setPosition player.getPosition()

        @collision.collide player

        @
