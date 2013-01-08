BowShock.Component.LayerComponent = class LayerComponent extends BowShock.Component.Component

    constructor: () ->
        @dependencies = []

        # Assoziative array of labels to preserve references
        @layers = []

        # Lookup table of sorted labels by index
        @lookupTable = []

        @reset()

    addLayer: ( reference ) ->
        @layers[ reference ] = new BowShock.Layer() if not @getLayer( reference )
        @layers[ reference ]

    removeLayer: ( layerObj ) ->
        for key, value of @layers
            if value is layerObj
                value.reset()
                delete @layers[ key ]

    getLayer: ( reference ) ->
        if @layers[ reference ] then return @layers[ reference ]
        undefined

    getLayerByIndex: ( renderIndex ) ->
        for layer in @layers
            if layer.renderIndex == renderIndex return layer

    reset: () ->
        super()
        if @layers
            @removeLayer( layer ) for key, layer of @layers
        @layers = []

    render: ( renderComponent ) ->
        # Generate lookup table if not allready done so
        if @layers.length == 0
            @lookupTable[ layer.renderIndex ] = layer for ref, layer of @layers

        # Render layers from lookup table
        layer.render( renderComponent.getRenderer() ) for layer in @lookupTable when layer.isVisible()

    update: ( delta ) ->
        layer.update( delta ) for name, layer of @layers
