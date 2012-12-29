BowShock.Entity = class Entity

    colliders: []

    position: null

    constructor: (@type, @collisionManager) ->
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

    collide: (originColliderTag, withTagName) ->
        collisions = @collisionManager.collide @
        if collisions.length is 0 then return false
        for collision in collisions
            if collision.origin.getTag() is originColliderTag and collision.destination.getTag() is withTagName
                return true
        false

    collideAt: (originColliderTag, withTagName, x, y) ->
        pre = @position
        @position.set x, y
        collision = @collide originColliderTag, withTagName
        @position.copy pre
        collision
