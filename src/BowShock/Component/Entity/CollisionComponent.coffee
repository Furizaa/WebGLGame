BowShock.Component.Entity.CollisionComponent = class ColissionComponent extends BowShock.Component.Component

    # Static
    @activeTypes: ["ET_PLAYER", "ET_ENEMY", "ET_BULLET"]

    # Static
    @colliders: []

    constructor: () ->
        @name = "Collision"
        @dependencies = [ "Transform" ]

    registerCollider: (collider, entity) ->
        collider.setEntity entity
        entity.addCollider collider
        @getColliders().push collider

    collide: (entity) ->
        collisions = []
        for inputCollider in entity.getColliders()
            for stockCollider in @getColliders()
                @check inputCollider, stockCollider, (ca, cb) =>
                    collisions.push
                        origin      : ca,
                        destination : cb
        collisions

    check: (a, b, onTrue) ->
        if ( a.getEntity() != b.getEntity() ) && a.getEntity().getType() in @getActiveTypes() && a.collideWith( b )
            onTrue.call @, a, b

    getColliders: () -> BowShock.Component.CollisionComponent.collider

    getActiveTypes: () -> BowShock.Component.CollisionComponent.activeTypes
