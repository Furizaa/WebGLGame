BowShock.StateLevel = class StateLevel extends BowShock.State

    load: () ->
        @addEntitie 'player', new BowShock.PlayerEntity()
        super()
        @