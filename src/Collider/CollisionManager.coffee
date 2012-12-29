BowShock.CollisionManager = class ColissionManager

    activeTypes: ["ET_PLAYER", "ET_ENEMY", "ET_BULLET"]

    colliders: []

    registerCollider: (collider, entity) ->
        collider.setEntity entity
        entity.addCollider collider
        @colliders.push collider

    collide: (entity) ->
        collisions = []
        for inputCollider in entity.getColliders()
            for stockCollider in @colliders
                @check inputCollider, stockCollider, (ca, cb) =>
                    collisions.push
                        origin      : ca,
                        destination : cb
        collisions

    check: (a, b, onTrue) ->
        if ( a.getEntity() != b.getEntity() ) && a.getEntity().getType() in @activeTypes && a.collideWith( b )
            onTrue.call @, a, b
