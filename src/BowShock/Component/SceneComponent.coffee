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
            @activeScene.unload() if @activeScene
            @activeScene = @toActivate
            @loading = true
            @toActivate.load ( loadedScene ) =>
                @loading = false

    getActiveScene: () ->
        @activeScene

    update: ( delta ) ->
        @getActiveScene().update delta if not @loading

    isLoading: () ->
        @loading