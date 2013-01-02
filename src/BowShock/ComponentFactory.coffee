# Singleton access
BowShock.ComponentFactory = class ComponentFactory
    _instance = undefined
    @instance: () ->
        _instance ?= new BowShock._ComponentFactory()

BowShock._ComponentFactory = class _ComponentFactory

    constructor: () ->

    buildComponent: ( componentName, componentAssembly ) ->
        if componentAssembly.getComponent componentName
            return componentAssembly.getComponent componentName

        console.log "Build Component", componentName if BowShock.debug
        buildComponent = new (BowShock.Component[ componentName + "Component" ] || BowShock.Component.Entity[ componentName + "Component" ])
        componentAssembly.addComponent buildComponent, componentName
        buildComponent.init componentAssembly

