BowShock.StateManager = class StateManager

    list: []

    constructor: (@renderer, @camera) ->

    add: (state) ->
        @list.push state

    render: () ->
        for state in @list
            do (state) =>
                @renderer.render state.getScene(), @camera

    update: () ->
        state.update() for state in @list when state.isActive()

    activate: (state) ->
        allstate.deactivate() for allstate in @list when allstate isnt state
        state.activate() if not state.isActive()
        @