BowShock.Component.Entity.SpriteComponent = class SpriteComponent extends BowShock.Component.Component

    # Handle materials static. We don't need them twice
    @materials: []

    constructor: () ->
        @name         = "Sprite"
        @dependencies = [ "Transform" ]
        @loaded       = false
        @flip =
            x: false
            y: false

    # Update: Bind values to necessary sibling Transform component
    update: ( delta ) ->
        if not @loaded then return @
        transform = @getDependencyComponent "Transform"
        @setPosition transform.getPosition()
        @setScale    transform.getScale()

    loadFile: ( @fileName, @tilesX, @tilesY, callbackDone ) ->
        console.log @fileName, "Load Sprite" if BowShock.debug
        map = THREE.ImageUtils.loadTexture @fileName, undefined, =>
            map.magFilter = THREE.NearestFilter
            map.minFilter = THREE.LinearMipMapLinearFilter

            if not @getMaterial()
                @setMaterial new THREE.SpriteMaterial
                    map:                  map
                    useScreenCoordinates: true
                @getMaterial().alignment = THREE.SpriteAlignment.center

            if @tilesX and @tilesY
                @getMaterial().uvScale.set( 1 / tilesX, 1 / tilesY )
                @setTile 0

            @tsprite = new THREE.Sprite @getMaterial()

            @tsprite.scale.set 0, 0

            @tsprite.opacity = 1
            @tsprite.position.normalize()

            callbackDone.call @, @name
            @loaded = true
            @

    loadJson: ( json, callbackDone ) ->
        @loadFile json.fileName, json.tilesX, json.tilesY, callbackDone
        @

    saveJson: () ->
        #TODO

    setPosition: ( vector ) ->
        if @loaded
            @tsprite.position.set vector.x, vector.y, 0

    getPosition: () ->
        if not @loaded then return new BowShock.Vector2 0, 0
        @tsprite.position

    setScale: ( vector ) ->
        if @loaded
            @tsprite.scale.set vector.x, vector.y, 0

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

    setTile: ( tile ) ->
        if not @tilesX or not @tilesY then return @
        tileX = tile % @tilesX
        tileY = Math.round( (tile / @tilesX) - .5 ) + 1
        uvX   = 1 / @tilesX * tileX
        uvY   = 1 - (1 / @tilesY) * tileY
        @getMaterial().uvOffset.set uvX, uvY
        @

    getSprite: () -> @tsprite

    getMaterial: -> BowShock.Component.Entity.SpriteComponent.materials[ @fileName ]

    setMaterial: ( material ) ->
        BowShock.Component.Entity.SpriteComponent.materials[ @fileName ] = material