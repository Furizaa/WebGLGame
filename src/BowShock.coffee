window.BowShock = class BowShock

    #Engine Namespaces
    @Component: {
        Entity: {}
    }
    @Collider: {}

    @contextWidth:  window.innerWidth
    @contextHeight: window.innerHeight

    @v2: (x, y) ->
        return new BowShock.Vector2(x, y)

    @debug: (text, layer = 1) ->
        $('.debug'+layer).text text

    @sign: (value, to) ->
        if value < 0 then return -to
        if value > 0 then return to
        to





