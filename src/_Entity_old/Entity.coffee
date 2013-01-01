BowShock.Entity = class Entity

    constructor: (@type, @collisionManager) ->
        @worldPosition = new BowShock.Vector2 0, 0
        @screenPosition = new BowShock.Vector2 0, 0
        @colliders = []
        @loaded = false

    init: () ->

    update: () ->

    getType: () ->
        @type

    isType: (type) ->
        @type == type

    isLoaded: () ->
        @loaded

    getWorldPosition: () ->
        @worldPosition

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
        pre = @worldPosition
        @worldPosition.set x, y
        collision = @collide originColliderTag, withTagName
        @worldPosition.copy pre
        collision
