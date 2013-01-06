BowShock.JSONSchema = class JSONSchema

    @thaw: ( value ) ->
        if typeof value != "string" then return value
        if parseFloat( value ) + "" == value
            return parseFloat( value )
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


