BowShock.LevelLoader = class LevelLoader

    constructor: (@scene) ->

    load: (json) ->
        @scene.getComponentFactory().loadJson json.scene, @scene, ( scene ) =>


