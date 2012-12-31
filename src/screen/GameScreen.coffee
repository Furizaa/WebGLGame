BowShock.GameScreen = class GameScreen extends BowShock.Screen

    playerSprite    : null

    anim:
        stand       : null
        move        : null
        slide       : null
        jump        : null
        fall        : null

    constructor: (name) ->
        super name
        @collision = new BowShock.CollisionManager()
        @level = new BowShock.Level @
        @

    load: () ->
        @playerSprite = new BowShock.Sprite "textures/move.png",
            tiles: new BowShock.Vector2( 16, 16 )
            scale: new BowShock.Vector2( 80, 80 )
        @playerSprite.load =>
            @playerSprite.setTile 33
            @anim.move  = new BowShock.SpriteAnimation @playerSprite, [35..40], 10, true
            @anim.stand = new BowShock.SpriteAnimation @playerSprite, [33], 1, false
            @anim.slide = new BowShock.SpriteAnimation @playerSprite, [41, 42], 3, false
            @anim.jump  = new BowShock.SpriteAnimation @playerSprite, [119], 1, false
            @anim.fall  = new BowShock.SpriteAnimation @playerSprite, [120], 1, false
            @playerSprite.addToBatch @getSpriteBatch()
            @loaded = true

        @addEntity 'player', new BowShock.PlayerEntity( @collision )

        @level.generate()

        super()
        @

    getCollisionManager: () ->
        @collision

    update: () ->
        super()
        player = @getEntity 'player'

        if player.isGrounded()
            if player.isRunning()
                @anim.move.play()
            else if player.isSliding()
                @anim.slide.play()
            else
                @anim.stand.play()
        else
            if player.isJumping()
                @anim.jump.play()
            if player.isFalling()
                @anim.fall.play()

        @playerSprite.flipX() if not player.isFacingRight() and not @playerSprite.flip.x
        @playerSprite.flipX() if     player.isFacingRight() and     @playerSprite.flip.x

        BowShock.spriteCam.centerOn player
        @playerSprite.setPosition player.getScreenPosition()

        @
