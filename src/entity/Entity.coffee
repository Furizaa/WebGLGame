BowShock.Entity = class Entity

    constructor: (@type, @collisionManager) ->
        @worldPosition = new BowShock.Vector2 0, 0
        @screenPosition = new BowShock.Vector2 0, 0
        @realtimePosition = new BowShock.Vector2 0, 0
        @colliders = []

    init: () ->

    update: () ->

    updateScreenPosition: () ->
        @screenPosition.x = @worldPosition.x + BowShock.spriteCam.x
        @screenPosition.y = @worldPosition.y + BowShock.spriteCam.y

    getType: () ->
        @type

    isType: (type) ->
        @type == type

    getWorldPosition: () ->
        @worldPosition

    getScreenPosition: () ->
        @updateScreenPosition()
        @screenPosition

    getRealtimePosition: () ->
        @realtimePosition

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
