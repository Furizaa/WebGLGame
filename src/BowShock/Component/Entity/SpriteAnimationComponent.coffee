BowShock.Component.Entity.SpriteAnimationComponent = class SpriteAnimationComponent extends BowShock.Component.Component

    constructor: () ->
        @dependencies = [ "SpriteComponent" ]
        @animations = {}
        super()

    addAnimation: ( name, frames, speed, looping = false, doneCallback ) ->
        @sprite ?= @getDependencyComponent( "SpriteComponent" )
        @animations[ name ] = new BowShock.SpriteAnimation @sprite, frames, speed, looping, doneCallback

    play: ( name, delta ) ->
        @animations[ name ].play( delta ) if @animations[ name ]

