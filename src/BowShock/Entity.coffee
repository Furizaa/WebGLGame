BowShock.Entity = class Entity extends BowShock.Component.ComponentAssembly

    constructor: () ->
        super()
        @transform = @getComponentFactory().buildComponent "Transform", @

    getType: () ->
        "ET_GENERIC"


