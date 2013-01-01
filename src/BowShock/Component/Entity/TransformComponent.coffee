BowShock.Component.Entity.TransformComponent = class TransformComponent extends BowShock.Component.EntityComponent

    constructor: () ->
        @name         = "Transform"
        @dependencies = []
        @position = new BowShock.Vector2 0, 0
        @scale    = new BowShock.Vector2 0, 0
        @rotation = 0

    loadJson: ( json, doneCallback ) ->
        @setPositionScalar  json.x,     json.y
        @setScaleScalar     json.width, json.height
        @setRotaion         json.angle
        doneCallback.call @, @name if doneCallback

    saveJson: () ->
        #todo

    getPosition: () ->
        @position

    setPosition: ( vector2 ) ->
        @setPositionScalar vector2.x, vector2.y

    setPositionScalar: ( x, y ) ->
        @position.x = x
        @position.y = y

    normalizePosition: () ->
        @position.x = Math.round @position.x
        @position.y = Math.round @position.y

    getScale: () ->
        @scale

    setScale: ( vector2 ) ->
        @setScaleScalar vector2.x, vector2.y

    setScaleScalar: ( x, y ) ->
        @scale.x = x
        @scale.y = y

    getRotation: () ->
        @rotation

    setRotaion: ( rotation ) ->
        @rotation = rotation


