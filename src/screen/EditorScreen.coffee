BowShock.EditorScreen = class EditorScreen extends BowShock.Screen

    constructor: (name) ->
        super name
        @

    load: () ->
        @loaded = true
        super()
        @

    update: () ->
        super()
        camera = BowShock.spriteCam
        camera.x -= 15 if BowShock.input.isKeyPressed( BowShock.Input.KEY_RIGHT )
        camera.x += 15 if BowShock.input.isKeyPressed( BowShock.Input.KEY_LEFT )
        camera.y += 15 if BowShock.input.isKeyPressed( BowShock.Input.KEY_UP )
        camera.y -= 15 if BowShock.input.isKeyPressed( BowShock.Input.KEY_DOWN )

        #if BowShock.input.isKeyPressed( BowShock.Input.KEY_E )
        #    BowShock.manager.activate BowShock.manager.get( "game" )