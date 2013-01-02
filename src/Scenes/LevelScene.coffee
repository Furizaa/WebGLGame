Core.Scene.LevelScene = class LevelScene extends BowShock.Scene

    load: ( doneCallback ) ->
        @active = @layers.addLayer "LR_ACTIVE"
        @active.setActive true

        level = BowShock.Config.instance().get()[ "level-preset" ]
        for entity in level.entities
            @getComponentFactory().loadJson entity, new Core.Entity.WorldEntity(), ( entity ) =>
                @active.addEntity entity

        @player = new Core.Entity.PlayerEntity().load ( player ) =>
            @active.addEntity player
            @active.getCamera().centerOn player

        super( doneCallback )

    update: ( delta ) ->
        super delta
        @active.getCamera().centerOn @player