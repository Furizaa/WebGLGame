BowShock.Component.Entity.SpriteComponent = class SpriteComponent extends BowShock.Component.Component

    # Handle materials static. We don't need them twice
    @materials: []

    constructor: () ->
        @dependencies = [ "TransformComponent" ]
        @loaded       = false
        @tilesX       = 1
        @tilesY       = 1
        @tile         = 0
        @flip =
            x: false
            y: false

    clone: ( parentAssembly, doneCallback ) ->
        console.log "CLONE SPRITE"
        clone = new BowShock.Component.Entity.SpriteComponent()
        clone.loaded = false
        clone.tilesX = @tilesX
        clone.tilesY = @tilesY
        clone.tile   = @tile
        clone.fileName = @fileName
        if clone.fileName
            clone.loadFile clone.fileName, clone.tilesX, clone.tilesY, ->
                doneCallback?.call @, clone, "SpriteComponent"
        clone

    # Update: Bind values to necessary sibling Transform component
    update: ( delta ) ->
        if not @loaded then return @
        transform = @getDependencyComponent "TransformComponent"
        @setPosition transform.getPosition()
        @setScale    transform.getScale()

    loadFile: ( @fileName, @tilesX, @tilesY, callbackDone ) ->
        map = THREE.ImageUtils.loadTexture @fileName, undefined, =>
            map.magFilter = THREE.NearestFilter
            map.minFilter = THREE.LinearMipMapLinearFilter

            if not @getMaterial()
                @setMaterial new THREE.SpriteMaterial
                    map:                  map
                    useScreenCoordinates: true
                @getMaterial().alignment = THREE.SpriteAlignment.center

            if @tilesX and @tilesY
                @setTiles @tilesX, @tilesY
                @setTile @tile

            @tsprite = new THREE.Sprite @getMaterial()

            @tsprite.scale.set 0, 0

            @tsprite.opacity = 1
            @tsprite.position.normalize()

            callbackDone?.call @
            @loaded = true
            @

    setTiles: ( @tilesX, @tilesY ) ->
        @getMaterial().uvScale.set( 1 / tilesX, 1 / tilesY )

    setPosition: ( vector ) ->
        if @loaded
            @tsprite.position.set vector.x, vector.y, 0

    getPosition: () ->
        if not @loaded then return new BowShock.Vector2 0, 0
        @tsprite.position

    setScale: ( vector ) ->
        if @loaded
            # Keep number signature
            @tsprite.scale.set BowShock.sign( @tsprite.scale.x, vector.x ), BowShock.sign( @tsprite.scale.y, vector.y ), 0

    getScale: () ->
        if not @loaded then return new BowShock.Vector2 0, 0
        @tsprite.scale

    flipX: () ->
        if not @loaded then return @
        @flip.x = not @flip.x
        @tsprite.scale.x = -@tsprite.scale.x
        @

    flipY: () ->
        if not @loaded then return @
        @flip.y = not @flip.y
        @tsprite.scale.y = -@tsprite.scale.y
        @

    setTile: ( @tile ) ->
        if not @tilesX or not @tilesY then return @
        tileX = @tile % @tilesX
        tileY = Math.round( (@tile / @tilesX) - .5 ) + 1
        uvX   = 1 / @tilesX * tileX
        uvY   = 1 - (1 / @tilesY) * tileY
        @getMaterial().uvOffset.set uvX, uvY if @getMaterial()
        @

    getSprite: () -> @tsprite

    getMaterial: -> BowShock.Component.Entity.SpriteComponent.materials[ @fileName ]

    setMaterial: ( material ) ->
        BowShock.Component.Entity.SpriteComponent.materials[ @fileName ] = material