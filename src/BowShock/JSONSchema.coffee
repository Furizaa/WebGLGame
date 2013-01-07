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

    @serializeVector2: ( v ) ->
        return obj =
            x: v.x
            y: v.y

    @deSerializeVector2: ( j ) ->
        v = new BowShock.Vector2( 0, 0 )
        v.x = BowShock.JSONSchema.thaw( j.x )
        v.y = BowShock.JSONSchema.thaw( j.y )
        v

    @serializeLayer: ( layer ) ->
        return obj =
            speed:   BowShock.JSONSchema.serializeVector2 layer.speed
            active:  layer.active
            visible: layer.visible

    @serializeTransform: ( transform ) ->
        return obj =
            position: BowShock.JSONSchema.serializeVector2 transform.getPosition()
            scale: BowShock.JSONSchema.serializeVector2 transform.getScale()
            rotation: transform.getRotation()

    @serializeSprite: ( sprite ) ->
        return obj =
            fileName: sprite.fileName
            tilesX: sprite.tilesX
            tilesY: sprite.tilesY
            tile: sprite.tile

    @serializeRectCollider: ( collider ) ->
        return obj =
            width: collider.width
            height: collider.height
            offset: BowShock.JSONSchema.serializeVector2 collider.offset
            tag: collider.tag


