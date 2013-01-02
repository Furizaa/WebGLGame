BowShock.Component.ComponentAssembly = class ComponentAssembly

    constructor: () ->
        @_components = []
        @_updateLoop = []
        @_facory     = BowShock.ComponentFactory.instance()

    getComponentFactory: () ->
        @_facory

    addComponent: ( component, componentName ) ->
        component.setParentAssembly @
        @_components[ componentName ] = component
        @_updateLoop[ componentName ] = component if component.update
        component

    getComponent: ( componentName ) ->
        if @_components[ componentName ] then return @_components[ componentName ]
        undefined

    updateComponents: ( delta ) ->
        component.update( delta ) for name, component of @_updateLoop

    update: ( delta ) ->
        @updateComponents delta

