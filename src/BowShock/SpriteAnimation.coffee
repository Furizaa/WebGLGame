BowShock.SpriteAnimation = class SpriteAnimation

    frame:
        current: -1
        last:    -1

    constructor: (@sprite, @frames, @speed, @doLoop, @endCallback) ->
        @reset()
        @length = @frames.length - 1

    reset: () ->
        @_pointer = 0
        @

    update: ( delta ) ->
        @_pointer += delta * @speed
        rpointer   = Math.round @_pointer
        @endCallback.call()         if rpointer > @length and @endCallbackd
        @reset()                    if rpointer > @length and @doLoop
        @

    play: ( delta ) ->
        @update delta
        @frame.current = @getFrame()
        @sprite.setTile( @frame.current ) if @frame.current != @frame.last
        @frame.last = @frame.current

    getFrame: () ->
        @frames[ Math.min( Math.round( @_pointer ), @length ) ]

    getSprite: () ->
        @sprite
