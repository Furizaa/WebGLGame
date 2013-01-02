BowShock.Component.Entity.SpriteAnimationComponent = class SpriteAnimationComponent extends BowShock.Component.Component

    constructor: () ->
        @dependencies = [ "Sprite" ]
        @animations = {}
        super()

    addAnimation: ( name, frames, speed, looping = false, doneCallback ) ->
        @sprite ?= @getDependencyComponent( "Sprite" )
        @animations[ name ] = new BowShock.SpriteAnimation @sprite, frames, speed, looping, doneCallback

    play: ( name, delta ) ->
        @animations[ name ].play( delta ) if @animations[ name ]

