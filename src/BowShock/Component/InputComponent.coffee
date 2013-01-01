BowShock.KEY_UP      = 87            # W
BowShock.KEY_DOWN    = 83            # S
BowShock.KEY_LEFT    = 65            # A
BowShock.KEY_RIGHT   = 68            # D
BowShock.KEY_SPACE   = 32            # SPACE
BowShock.KEY_E       = 69

BowShock.Component.InputComponent = class InputComponent extends BowShock.Component.Component

    # Static
    @currentKeys     : []
    @previousKeys    : []
    @systemKeys      : []
    @eventsPlaced    : false

    constructor: () ->
        super()
        @dependencies = []

        # Make shure we dont add listeners twice
        if not BowShock.Component.InputComponent.eventsPlaced
            document.addEventListener 'keydown', @onKeyDown, false
            document.addEventListener 'keyup', @onKeyUp, false
        BowShock.Component.InputComponent.eventsPlaced = true
        @

    # Called from ComponentAssembly
    update: ( delta ) ->
        @_previousKeys()[ key ] = state for state, key in @_currentKeys()
        @_currentKeys()[ key ]  = state for state, key in @_systemKeys()

    onKeyDown: ( event ) =>
        @_systemKeys()[ event.keyCode ] = true

    onKeyUp: ( event ) =>
        @_systemKeys()[ event.keyCode ] = false

    isKeyPressed: ( code ) ->
        @_currentKeys()[ code ] and not @_previousKeys()[ code ]

    isKeyHeld: ( code ) ->
        @_currentKeys()[ code ]

    isKeyReleased: ( code ) ->
        @_previousKeys()[ code ] and not @_currentKeys()[ code ]

    _currentKeys:  -> BowShock.Component.InputComponent.currentKeys
    _previousKeys: -> BowShock.Component.InputComponent.previousKeys
    _systemKeys:   -> BowShock.Component.InputComponent.systemKeys
