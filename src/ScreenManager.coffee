BowShock.ScreenManager = class ScreenManager

    list: []

    constructor: (@renderer, @camera) ->

    add: (screen) ->
        @list.push screen

    render: () ->
        for screen in @list
            do (screen) =>
                @renderer.render screen.getSpriteBatch(), @camera

    update: () ->
        screen.update() for screen in @list when screen.isActive()

    activate: (screen) ->
        allstate.deactivate() for allstate in @list when allstate isnt screen
        screen.activate() if not screen.isActive()
        @