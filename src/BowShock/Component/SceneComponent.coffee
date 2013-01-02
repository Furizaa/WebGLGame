BowShock.Component.SceneComponent = class SceneComponent extends BowShock.Component.Component

    constructor: () ->
        @dependencies = []
        @toActivate   = null
        @activeScene  = null
        @loading      = true

    init: () ->
        super()

    activateScene: ( scene ) ->
        @toActivate = scene

    resolveSceneChanges: () ->
        if @activeScene != @toActivate
            @loading = true
            @activeScene.unload() if @activeScene
            @toActivate.load ( loadedScene ) =>
                @activeScene = loadedScene
                @loading = false

    getActiveScene: () ->
        @activeScene

    update: ( delta ) ->
        @getActiveScene().update delta if not @loading

    isLoading: () ->
        @loading