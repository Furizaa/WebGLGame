BowShock.Input = class Input

    @KEY_UP      = 87            # W
    @KEY_DOWN    = 83            # S
    @KEY_LEFT    = 65            # A
    @KEY_RIGHT   = 68            # D
    @KEY_SPACE   = 32            # SPACE
    @KEY_E       = 69

    currentKeys = []
    previousKeys = []
    systemKeys = []

    constructor: ->
        document.addEventListener 'keydown', @onKeyDown, false
        document.addEventListener 'keyup', @onKeyUp, false

    update: ->
        previousKeys[ key ] = state for state, key in currentKeys
        currentKeys[ key ]  = state for state, key in systemKeys

    onKeyDown: ( event ) =>
        systemKeys[ event.keyCode ] = true

    onKeyUp: ( event ) =>
        systemKeys[ event.keyCode ] = false

    isKeyPressed: ( code ) ->
        currentKeys[ code ] and not previousKeys[ code ]

    isKeyHeld: ( code ) ->
        currentKeys[ code ]

    isKeyReleased: ( code ) ->
        previousKeys[ code ] and not currentKeys[ code ]
