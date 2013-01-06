BowShock.LevelLoader = class LevelLoader

    constructor: (@scene) ->

    load: (json, doneCallback) ->
        @scene.getComponentFactory().loadJson json.scene, @scene, ( scene ) =>
            doneCallback?.call scene


