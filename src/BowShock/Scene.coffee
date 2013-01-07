BowShock.Scene = class Scene extends BowShock.Component.ComponentAssembly

    @loaded

    constructor: () ->
        super()
        @layers   = @getComponentFactory().buildComponent "LayerComponent", @
        @input    = @getComponentFactory().buildComponent "InputComponent", @

    render: ( renderComponent ) ->
        @layers.render renderComponent if @loaded

    update: ( delta ) ->
        super delta
        @layers.update delta if @loaded

    # Overwrite
    load: ( doneCallback ) ->
        @loaded = true
        doneCallback?.call @, @
        @

    # Overwrite
    unload: () ->
        @loaded = false
        @



