Core.Scene.LevelScene = class LevelScene extends BowShock.Scene

    load: ( doneCallback ) ->
        console.log "LOAD"
        $.getJSON '/level/new.json', ( jsonLevel ) =>
            if not jsonLevel.scene then return
            @getComponentFactory().onSprite = ( sprite ) ->
                entity = sprite.parentAssembly
                entity.layer.enableEntityRender entity
            @getComponentFactory().loadJson jsonLevel.scene, @
            @loadingMonitor = @getComponentFactory().getMonitor()
            @loadingMonitor.onFinish =>

                @active = @layers.getLayer( "LY_MAIN" )
                @active.active = true

                @player = new Core.Entity.PlayerEntity().load ( player ) =>
                    @active.addEntity player
                    @active.getCamera().centerOn player

                    #for key, layer of @layers.layers
                    #    @active.enableEntityRender entity for entity in layer.entities

                    super( doneCallback )


    update: ( delta ) ->
        super delta
        @active.getCamera().centerOn @player

