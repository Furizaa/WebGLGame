BowShock.Collider.Collider = class Collider

    entity: null

    constructor: (@tag, @relative) ->

    setEntity: (entity) ->
        @entity = entity

    getEntity: () ->
        @entity

    getTag: () ->
        @tag

    getEntityPosition: () ->
        if @entity then @entity.getWorldPosition() else new BowShock.Vector2(0, 0)

    getOffset: () ->
        if @relative then @getEntityPosition().clone().addSelf( @offset ) else @offset

    collideWith: (other) ->
        typeA = @getColliderType()
        typeB = other.getColliderType()

        if typeA is "CT_RECT"   and typeB is "CT_RECT"    then return @collideRectWithRect @, other
        if typeA is "CT_RECT"   and typeB is "CT_CIRCLE"  then return @collideRectWithCircle @, other
        if typeA is "CT_CIRCLE" and typeB is "CT_RECT"    then return @collideRectWithCircle other, @

    collideRectWithRect: (a, b) ->
        if a.getBottom() < b.getTop()       then return false
        if a.getTop()    > b.getBottom()    then return false
        if a.getRight()  < b.getLeft()      then return false
        if a.getLeft()   > b.getRight()     then return false
        true

    collideRectWithCircle: (rect, circle) ->

        #Center of Circle is whitin Rectange
        if rect.intersectPoint( circle.getCenter() ) then return true

        pA = rect.getTopLeft()
        pB = rect.getTopRight()
        pC = rect.getBottomRight()
        pD = rect.getBottomLeft()

        if circle.intersectLine( pA, pB ) then return true
        if circle.intersectLine( pB, pC ) then return true
        if circle.intersectLine( pD, pC ) then return true
        if circle.intersectLine( pA, pD ) then return true

        false

