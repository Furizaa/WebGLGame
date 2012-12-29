BowShock.RectangleCollider = class RectangleCollider extends BowShock.Collider

    constructor: (@tag, @width, @height, @offset, @relative) ->
        super( @tag, @relative )
        if BowShock.debug
            @d = $('<div>').addClass('collider')
            $('.debugLayer').append @d
        @

    getColliderType: () ->
        if BowShock.debug
            @d.css
                left: @getLeft()
                top: @getTop()
                width: @getRight() - @getLeft()
                height: @getBottom() - @getTop()
        "CT_RECT"

    intersectPoint: (point) ->
        point.x > @getLeft() && point.x < @getRight() && point.y > @getTop() && point.y < @getBottom()

    intersectLine: (start, end) ->
        @intersectPoint( start ) || @intersectPoint( end )

    getRight: () ->
        @getOffset().x + @width

    getLeft: () ->
        @getOffset().x

    getTop: () ->
        @getOffset().y

    getBottom: () ->
        @getOffset().y + @height

    getTopLeft: () ->
        new BowShock.Vector2 @getLeft(), @getTop()

    getTopRight: () ->
        new BowShock.Vector2 @getRight(), @getTop()

    getBottomLeft: () ->
        new BowShock.Vector2 @getLeft(), @getBottom()

    getBottomRight: () ->
        new BowShock.Vector2 @getRight(), @getBottom()



