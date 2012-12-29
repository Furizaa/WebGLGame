window.BowShock = class BowShock

    @v2: (x, y) ->
        return new BowShock.Vector2(x, y)

    @debug: true

    @debug: (text, layer = 1) ->
        $('.debug'+layer).text text

    @sign: (value, to) ->
        if value < 0 then return -to
        if value > 0 then return to
        to

