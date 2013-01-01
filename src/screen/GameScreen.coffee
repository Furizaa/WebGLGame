BowShock.GameScreen = class GameScreen extends BowShock.Screen

    constructor: (name) ->
        super name
        @collision = new BowShock.CollisionManager()
        @level = new BowShock.Level @
        @

    load: () ->
        @addEntity 'player', new BowShock.PlayerEntity( @collision )
        @level.generate()
        @loaded = true
        super()
        @

    update: () ->
        super()
        if BowShock.input.isKeyPressed( BowShock.Input.KEY_E )
            BowShock.manager.activate BowShock.manager.get( "editor" )

    getCollisionManager: () ->
        @collision

