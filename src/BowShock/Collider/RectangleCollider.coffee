BowShock.Collider.RectangleCollider = class RectangleCollider extends BowShock.Collider.Collider

    constructor: (@tag, @width, @height, @offset, @relative) ->
        super( @tag, @relative )
        @

    clone: ( ) ->
        new BowShock.Collider.RectangleCollider @tag, @width, @height, @offset.clone(), @relative

    getColliderType: () ->
        "CT_RECT"

    intersectPoint: (point) ->
        point.x > @getLeft() && point.x < @getRight() && point.y > @getTop() && point.y < @getBottom()

    intersectLine: (start, end) ->
        @intersectPoint( start ) || @intersectPoint( end )

    getRight: () ->
        @getOffset().x + ( @width / 2 )

    getLeft: () ->
        @getOffset().x - ( @width / 2 )

    getTop: () ->
        @getOffset().y - ( @height / 2 )

    getBottom: () ->
        @getOffset().y + ( @height / 2 )

    getTopLeft: () ->
        new BowShock.Vector2 @getLeft(), @getTop()

    getTopRight: () ->
        new BowShock.Vector2 @getRight(), @getTop()

    getBottomLeft: () ->
        new BowShock.Vector2 @getLeft(), @getBottom()

    getBottomRight: () ->
        new BowShock.Vector2 @getRight(), @getBottom()

    getWidth: () ->
        @width

    getHeight: () ->
        @height



