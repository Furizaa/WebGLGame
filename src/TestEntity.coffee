Core.TestEntity = class TestEntity extends BowShock.Entity

    load: (doneCallback) ->
        @sprite = @assembly.addComponent( "Sprite" ).init()
        @sprite.loadFile "textures/testbox2.png", undefined, undefined, =>
            @loaded = true
            doneCallback.call @

        @transform.setScaleScalar 800, 600
        @transform.setPositionScalar 400, 300
        @