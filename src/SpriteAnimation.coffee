BowShock.SpriteAnimation = class SpriteAnimation

    frame:
        current: -1
        last:    -1

    constructor: (@sprite, @frames, @speed, @endCallback) ->
        @reset()

    reset: () ->
        @_pointer = 0
        @

    update: () ->
        @_pointer += BowShock.delta * @speed
        rpointer   = Math.round @_pointer
        @reset()            if rpointer >= @frames.length
        @endCallback.call() if rpointer == @frames.length and @endCallback

        @frame.current = @getFrame()
        @sprite.setTile( @frame.current ) if @frame.current != @frame.last
        @frame.last = @frame.current
        @

    stop: () ->
        @stopped = true
        @

    resume: () ->
        @stopped = false
        @

    getFrame: () ->
        @frames[ Math.round( @_pointer ) ]

    getSprite: () ->
        @sprite
