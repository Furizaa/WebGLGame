Core.Scene.LevelScene = class LevelScene extends BowShock.Scene

    load: ( doneCallback ) ->
        console.log "LOAD"
        $.getJSON '/level/new.json', ( jsonLevel ) =>
            if not jsonLevel.scene then return
            loader = new BowShock.LevelLoader @
            loader.load jsonLevel, =>

                @active = @layers.getLayer( "LY_HOT" )
                @active.active = true

                @player = new Core.Entity.PlayerEntity().load ( player ) =>
                    @active.addEntity player
                    @active.enableEntityRender entity for entity in @active.entities
                    @active.getCamera().centerOn player

                    super( doneCallback )


    update: ( delta ) ->
        super delta
        @active.getCamera().centerOn @player

