BowShock.Component.ComponentAssembly = class ComponentAssembly

    constructor: () ->
        @components = []
        @updateLoop = []

    addComponent: ( componentName ) ->
        if not @_( componentName )
            console.log componentName, "Add Component" if BowShock.debug
            newComponent = new (BowShock.Component[ componentName + "Component" ] || BowShock.Component.Entity[ componentName + "Component" ])
            newComponent.setParentAssembly @
            @components[ componentName ] = newComponent
            @updateLoop[ componentName ] = newComponent if newComponent.update
        @_( componentName )

    getComponent: ( componentName ) ->
        if @components[ componentName ] then return @components[ componentName ]
        undefined

    # Short alias for getComponent
    _: ( componentName ) ->
        @getComponent( componentName )

    updateComponents: ( delta ) ->
        component.update( delta ) for name, component of @updateLoop
