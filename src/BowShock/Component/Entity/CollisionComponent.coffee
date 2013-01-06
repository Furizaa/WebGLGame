BowShock.Component.Entity.CollisionComponent = class ColissionComponent extends BowShock.Component.Component

    # Static
    @activeTypes: ["ET_PLAYER", "ET_ENEMY", "ET_BULLET"]

    # Static
    @colliders: []

    constructor: () ->
        @name = "Collision"
        @localColliders = []
        @dependencies = [ "TransformComponent" ]

    registerCollider: ( collider ) ->
        collider.setEntity   @parentAssembly
        @localColliders.push collider
        @getColliders().push collider

    getCollider: ( tag ) ->
        collider = pointer for pointer in @localColliders when pointer.getTag() is tag
        collider

    collide: ( originColliderTag, withTagName ) ->
        collisions = []
        for localCollider in @localColliders
            for globalCollider in @getColliders()
                @check localCollider, globalCollider, (ca, cb) =>
                    collisions.push
                        origin      : ca,
                        destination : cb

        if collisions.length is 0 then return false
        for collision in collisions
            if collision.origin.getTag() is originColliderTag and collision.destination.getTag() is withTagName
                return true
        false

    check: ( a, b, onTrue ) ->
        if ( a.getEntity() != b.getEntity() ) && a.getEntity().getType() in @getActiveTypes() && a.collideWith( b )
            onTrue.call @, a, b

    getColliders: () -> BowShock.Component.Entity.CollisionComponent.colliders

    getActiveTypes: () -> BowShock.Component.Entity.CollisionComponent.activeTypes

    clone: ( parentAssembly, doneCallback ) ->
        console.log "CLONE COLLISION"
        clone = new BowShock.Component.Entity.CollisionComponent()
        clone.parentAssembly = parentAssembly
        for collider in @localColliders
            clone.registerCollider collider.clone()
        doneCallback?.call @, clone, "CollisionComponent"

