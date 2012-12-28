BowShock.Entity = class Entity

    colliders: []

    position: null

    constructor: (@type) ->
        @position = new BowShock.Vector2 0, 0

    init: () ->

    update: () ->

    getType: () ->
        @type

    isType: (type) ->
        @type == type

    getPosition: () ->
        @position

    addCollider: (collider) ->
        @colliders.push collider

    getColliders: () ->
        @colliders