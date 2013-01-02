BowShock.Collider.Collider = class Collider

    constructor: (@tag, @relative) ->
        @entity = null

    setEntity: (entity) ->
        @entity = entity
        if BowShock.debugHtml
            @d = $('<div>').addClass('collider ' + @tag)
            $('.debugLayer').append @d
            @d.css
                left: @getLeft() + (BowShock.contextWidth / 2)
                top: @getTop() + (BowShock.contextHeight / 2)
                width: @getWidth()
                height: @getHeight()

    getEntity: () ->
        @entity

    getTag: () ->
        @tag

    getEntityTransform: () ->
        @entityTransform ?= @entity.getComponent( "Transform" )

    getEntityPosition: () ->
        if @entity then @getEntityTransform().getPosition() else new BowShock.Vector2(0, 0)

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

