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
                @check inputCollider, stockCollider, (entity) =>
                    collisions.push entity
        collisions

    check: (a, b, onTrue) ->
        if ( a.getEntity() != b.getEntity() ) && a.getEntity().getType() in @activeTypes && @checkTwoInstances(a, b)
            console.log "!!"
            onTrue.call @, b.getEntity
        else
            BowShock.debug "NO-COLLISION", 2

    checkTwoInstances: (a, b) ->
        typeA = a.getColliderType()
        typeB = b.getColliderType()

        if typeA is "CT_RECT" and typeB is "CT_RECT"
            return @collideRectRect a, b

        false

    collideRectRect: (a, b) ->
        if a.getBottom() < b.getTop()       then return false
        BowShock.debug "0", 3
        if a.getTop()    > b.getBottom()    then return false
        BowShock.debug "1", 3
        if a.getRight()  < b.getLeft()      then return false
        BowShock.debug "2", 3
        if a.getLeft()   > b.getRight()     then return false
        BowShock.debug "3", 3
        return true
