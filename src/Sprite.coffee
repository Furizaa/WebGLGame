BowShock.Sprite = class Sprite

    tsprite: null

    tmaterial: null

    loaded: false

    flip:
        x: false
        y: false

    projector: new THREE.Projector()

    ###
    options:
        tiles:      BowShock.Vector2
        scale:      BowShock.Vector2
        magFilter   THREE.Filter
        minFilter   THREE.Filter
    ###
    constructor: (@file, @options) ->

    load: (callbackDone) ->
        map = THREE.ImageUtils.loadTexture @file, undefined, =>
            map.magFilter = @options.magFilter || THREE.NearestFilter
            map.minFilter = @options.minFilter || THREE.LinearMipMapLinearFilter
            @tmaterial = new THREE.SpriteMaterial
                map:                    map
                aligment:               THREE.SpriteAlignment.topLeft
                useScreenCoordinates:   true


            if @options.tiles
                @tmaterial.uvScale.set( 1 / @options.tiles.x, 1 / @options.tiles.y )
                @setTile 0

            @tsprite = new THREE.Sprite @tmaterial

            if @options.scale
                @tsprite.scale.set @options.scale.x, @options.scale.y

            @tsprite.opacity = 1
            @tsprite.position.normalize()

            callbackDone.call()
            @loaded = true
            @

    addToBatch: (batch) ->
        batch.add @tbounds
        batch.add @tsprite

    setPosition: (position) ->
        if @loaded
            position.apply Math.round
            @tsprite.position.x = position.x
            @tsprite.position.y = position.y
        @

    getPosition: () ->
        @tsprite.position

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
        @tmaterial.uvOffset.set uvX, uvY
        @

