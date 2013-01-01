BowShock.ScreenManager = class ScreenManager

    constructor: (@renderer, @camera) ->
        @list = []
        @

    add: (screen) ->
        @list.push screen

    get: (name) ->
        for screen in @list
            if screen.getName() == name then return screen
        return null

    render: () ->
        screen.render(@renderer, @camera) for screen in @list when screen.isLoaded()

    update: () ->
        screen.update() for screen in @list when screen.isActive() and screen.isLoaded()

    activate: (screen) ->
        allstate.deactivate() for allstate in @list when allstate isnt screen
        screen.activate() if not screen.isActive()
        @