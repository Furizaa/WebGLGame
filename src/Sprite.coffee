BowShock.Sprite = class Sprite

    materials: {}

    ###
    options:
        tiles:      BowShock.Vector2
        scale:      BowShock.Vector2
        magFilter   THREE.Filter
        minFilter   THREE.Filter
    ###
    constructor: (@file, @options) ->
        @position = new BowShock.Vector2(0, 0)
        @tsprite = null
        @loaded = false
        @flip =
            x: false
            y: false

    load: (callbackDone) ->
        map = THREE.ImageUtils.loadTexture @file, undefined, =>
            map.magFilter = @options.magFilter || THREE.NearestFilter
            map.minFilter = @options.minFilter || THREE.LinearMipMapLinearFilter

            if not @_material()
                @materials[ @file ] = new THREE.SpriteMaterial
                    map:                    map
                    useScreenCoordinates:   true
                @_material().alignment = THREE.SpriteAlignment.center


            if @options.tiles
                @_material().uvScale.set( 1 / @options.tiles.x, 1 / @options.tiles.y )
                @setTile 0

            @tsprite = new THREE.Sprite @_material()

            if @options.scale
                @tsprite.scale.set @options.scale.x, @options.scale.y

            @tsprite.opacity = 1
            @tsprite.position.normalize()

            callbackDone.call()
            @loaded = true
            @

    _material: () ->
        @materials[ @file ]

    addToBatch: (batch) ->
        batch.add @

    setPosition: (position) ->
        if @loaded
            @position.x = position.x
            @position.y = position.y
        @

    getPosition: () ->
        @position

    flipX: () ->
        @flip.x = not @flip.x
        @tsprite.scale.x = -@tsprite.scale.x
        @

    flipY: () ->
        @flip.y = not @flip.y
        @tsprite.scale.y = -@tsprite.scale.y
        @

    setTile: (tile) ->
        if not @options.tiles then return @
        tileX = tile % @options.tiles.x
        tileY = Math.round( (tile / @options.tiles.x) - .5 ) + 1
        uvX   = 1 / @options.tiles.x * tileX
        uvY   = 1 - (1 / @options.tiles.y) * tileY
        @_material().uvOffset.set uvX, uvY
        @

