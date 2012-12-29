BowShock.CircleCollider = class CircleCollider extends BowShock.Collider

    constructor: (@tag, @radius, @offset, @relative) ->
        super( @tag, @relative )
        if BowShock.debug
            @d = $('<div>').addClass('collider circle')
            $('.debugLayer').append @d
        @

    getColliderType: () ->
        if BowShock.debug
            @d.css
                left: @getCenterX() - @radius
                top:  @getCenterY() - @radius
                width:  @radius * 2
                height: @radius * 2
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


    getCenterX: () ->
        @getOffset().x

    getCenterY: () ->
        @getOffset().y

    getCenter: () ->
        @getOffset()



