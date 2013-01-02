BowShock.Collider.CircleCollider = class CircleCollider extends BowShock.Collider.Collider

    constructor: (@tag, @radius, @offset, @relative) ->
        super( @tag, @relative )
        @

    getColliderType: () ->
        "CT_CIRCLE"

    intersectPoint: (point) ->
        getCenter().distanceTo( point ) <= @radius

    # http://www.gamedev.net/topic/304578-finite-line-circle-intersection/
    intersectLine: (start, end) ->
        center = @getCenter()
        radius = @radius
        dir    = end.clone().subSelf( start )
        diff   = center.clone().subSelf( start )
        t      = diff.dot( dir ) / ( Math.pow(dir.x, 2) + Math.pow(dir.y, 2) )
        if t < 0.0
            t = 0.0
        if t > 1.0
            t = 1.0

        dir.x *= t
        dir.y *= t
        closest  = start.clone().addSelf( dir )
        dist     = center.clone().subSelf( closest )
        distsqrt = ( Math.pow(dist.x, 2) + Math.pow(dist.y, 2) )

        return distsqrt <= radius * radius

    getTop: () ->
        @getCenterY() - @radius

    getLeft: () ->
        @getCenterX() - @radius

    getCenterX: () ->
        @getOffset().x

    getCenterY: () ->
        @getOffset().y

    getCenter: () ->
        @getOffset()

    getWidth: () ->
        @radius * 2

    getHeight: () ->
        @getWidth()



