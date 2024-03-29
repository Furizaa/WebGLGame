BowShock.Component.LayerComponent = class LayerComponent extends BowShock.Component.Component

    constructor: () ->
        @dependencies = []
        @reset()

    addLayer: ( reference ) ->
        @layers[ reference ] = new BowShock.Layer() if not @getLayer( reference )
        @layers[ reference ]

    removeLayer: ( layerObj ) ->
        for key, value of @layers
            if value is layerObj
                value.reset()
                delete @layers[ key ]

    reset: () ->
        super()
        if @layers
            @removeLayer( layer ) for key, layer of @layers
        @layers = []

    render: ( renderComponent ) ->
        layer.render( renderComponent.getRenderer() ) for name, layer of @layers when layer.isVisible()

    update: ( delta ) ->
        layer.update( delta ) for name, layer of @layers

    getLayer: ( reference ) ->
        if @layers[ reference ] then return @layers[ reference ]
        undefined