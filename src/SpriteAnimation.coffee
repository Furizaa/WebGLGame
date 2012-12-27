BowShock.SpriteAnimation = class SpriteAnimation

    constructor: (@frames, @speed) ->
        @timer = new THREE.Clock true
        @reset()

    reset: () ->
        @_pointer = 0.0
        @

    update: () ->
        @_pointer += @timer.getDelta() * @speed
        @reset() if Math.round( @_pointer ) >= @frames.length
        @

    stop: () ->
        @stopped = true
        @

    resume: () ->
        @stopped = false
        @

    getFrame: () ->
        @frames[ Math.round( @_pointer ) ]
