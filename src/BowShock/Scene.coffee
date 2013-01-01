BowShock.Scene = class Scene

    @loaded

    constructor: () ->
        @assembly = new BowShock.Component.ComponentAssembly()
        @renderer = @assembly.addComponent( "Render" ).init()
        @layers   = @assembly.addComponent( "Layer" ).init()
        @input    = @assembly.addComponent( "Input" ).init()

    render: () ->
        @layers.render @renderer if @loaded

    update: ( delta ) ->
        @layers.update delta if @loaded

    # Overwrite
    load: ( doneCallback ) ->
        @loaded = true
        doneCallback.call @ if doneCallback
        @

    # Overwrite
    unload: () ->
        @loaded = false
        @



