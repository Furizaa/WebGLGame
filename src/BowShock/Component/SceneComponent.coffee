BowShock.Component.SceneComponent = class SceneComponent extends BowShock.Component.Component

    constructor: () ->
        @dependencies = []
        @toActivate   = null
        @activeScene  = null

    init: () ->
        super()

    activateScene: ( scene ) ->
        @toActivate = scene

    resolveSceneChanges: () ->
        if @activeScene != @toActivate
            @activeScene.unload() if @activeScene
            @activeScene = @toActivate.load()

    getActiveScene: () ->
        @activeScene

    update: ( delta ) ->
        @getActiveScene().update delta