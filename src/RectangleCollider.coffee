BowShock.RectangleCollider = class RectangleCollider extends BowShock.Collider

    constructor: (@width, @height, @offset, @relative) ->
        super( @relative )
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
        offset = if @relative then (@getEntityPosition().x + @offset.x) else @offset.x
        offset + @width * 0.5

    getLeft: () ->
        offset = if @relative then (@getEntityPosition().x + @offset.x) else @offset.x
        offset - @width * 0.5

    getTop: () ->
        offset = if @relative then (@getEntityPosition().y + @offset.y) else @offset.x
        offset - @height * 0.5

    getBottom: () ->
        offset = if @relative then (@getEntityPosition().y + @offset.y) else @offset.x
        offset + @height * 0.5

    getTopLeft: () ->
        new BowShock.Vector2 @getLeft(), @getTop()

    getTopRight: () ->
        new BowShock.Vector2 @getRight(), @getTop()

    getBottomLeft: () ->
        new BowShock.Vector2 @getLeft(), @getBottom()

    getBottomRight: () ->
        new BowShock.Vector2 @getRight(), @getBottom()


