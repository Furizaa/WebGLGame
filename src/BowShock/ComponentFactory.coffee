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

    loadJson: ( json, componentAssembly, doneCallback ) ->
        loadMonitor = []
        for entry in json
            loadMonitor[ entry.componentName ] = false
            component = @buildComponent entry.componentName, componentAssembly
            @[ "loadJson" + entry.componentName ].call @, entry.componentData, component, componentAssembly, ( name ) =>
                loadMonitor[ name ] = true
                allLoaded = true
                for key, value of loadMonitor
                    allLoaded = false if not value
                if allLoaded
                    doneCallback.call @, componentAssembly if doneCallback


    loadJsonTransform: ( json, transform, componentAssembly, doneCallback ) ->
        transform.setPositionScalar  json.x,     json.y
        transform.setScaleScalar     json.width, json.height
        transform.setRotaion         json.angle
        doneCallback.call @, "Transform"

    loadJsonSprite: ( json, sprite, componentAssembly, doneCallback ) ->
        sprite.loadFile json.fileName, json.tilesX, json.tilesY, =>
            doneCallback.call @, "Sprite"

    loadJsonCollision: ( json, collision, componentAssembly, doneCallback ) ->
        for c in json
            offset   = new BowShock.Vector2 c.offsetx, c.offsety
            part     = new BowShock.Collider.RectangleCollider c.tag, c.width, c.height, offset, true
            collision.registerCollider part
        doneCallback.call @, "Collision"

