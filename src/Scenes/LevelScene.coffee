Core.Scene.LevelScene = class LevelScene extends BowShock.Scene

    constructor: () ->
        super()
        @

    load: ( doneCallback ) ->
        console.log "Level Load"
        @active = @layers.addLayer "LR_ACTIVE", new BowShock.Camera()
        @active.setActive true

        level = BowShock.Config.instance().get()[ "level0" ]
        for entity in level.entities
            new Core.Entity.WorldEntity().loadJson entity, ( entity ) =>
                @active.addEntity entity

        super( doneCallback )