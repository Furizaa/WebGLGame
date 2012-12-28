BowShock.Collider = class Collider

    entity: null

    constructor: (@relative) ->

    setEntity: (entity) ->
        @entity = entity

    getEntity: () ->
        @entity

    getEntityPosition: () ->
        if @entity then @entity.getPosition() else new BowShock.Vector2(0, 0)