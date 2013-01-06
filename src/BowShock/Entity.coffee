BowShock.Entity = class Entity extends BowShock.Component.ComponentAssembly

    constructor: () ->
        super()
        @renderEnabled = false
        @layer = undefined
        @getComponentFactory().buildComponent "TransformComponent", @

    clone: () ->
        new BowShock.Entity()

    getType: () ->
        "ET_GENERIC"


