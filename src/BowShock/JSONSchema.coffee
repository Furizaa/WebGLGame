BowShock.JSONSchema = class JSONSchema

    @thaw: ( value ) ->
        if typeof value != "string" then return value
        if parseFloat( value ) + "" == value
            return parseInt( value )
        if value.toLowerCase() == "true"
            return true
        if value.toLowerCase() == "false"
            return false
        return value

    @Vector2: ( v ) ->
        return obj =
            x: v.x
            y: v.y

    @Layer: ( layer ) ->
        return obj =
            speed:   BowShock.JSONSchema.Vector2 layer.speed
            active:  layer.active
            visible: layer.visible

    @Transform: ( transform ) ->
        return obj =
            position: BowShock.JSONSchema.Vector2 transform.getPosition()
            scale: BowShock.JSONSchema.Vector2 transform.getScale()
            rotation: transform.getRotation()

    @Sprite: ( sprite ) ->
        return obj =
            fileName: sprite.fileName
            tilesX: sprite.tilesX
            tilesY: sprite.tilesY
            tile: sprite.tile

    @RectCollider: ( collider ) ->
        return obj =
            width: collider.width
            height: collider.height
            offset: BowShock.JSONSchema.Vector2 collider.offset
            tag: collider.tag


