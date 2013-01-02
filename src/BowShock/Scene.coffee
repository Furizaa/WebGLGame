BowShock.Scene = class Scene extends BowShock.Component.ComponentAssembly

    @loaded

    constructor: () ->
        super()
        @layers   = @getComponentFactory().buildComponent "Layer", @
        @input    = @getComponentFactory().buildComponent "Input", @

    render: ( renderComponent ) ->
        @layers.render renderComponent if @loaded

    update: ( delta ) ->
        super delta
        @layers.update delta if @loaded

    # Overwrite
    load: ( doneCallback ) ->
        @loaded = true
        doneCallback.call @, @ if doneCallback
        @

    # Overwrite
    unload: () ->
        @loaded = false
        @



