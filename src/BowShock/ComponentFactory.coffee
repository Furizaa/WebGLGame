# Singleton access
BowShock.ComponentFactory = class ComponentFactory
    _instance = undefined
    @instance: () ->
        _instance ?= new BowShock._ComponentFactory()

BowShock._ComponentFactory = class _ComponentFactory

    ###
    Available Callbacks:
        onLayerComponent
        onlayer
    ###

    constructor: () ->

    buildComponent: ( componentName, componentAssembly ) ->
        if componentAssembly.getComponent componentName
            return componentAssembly.getComponent componentName

        if not /Component$/.test componentName then componentName += "Component"
        console.log "BUILD", componentName if BowShock.debug
        buildComponent = new (BowShock.Component[ componentName ] || BowShock.Component.Entity[ componentName ])
        componentAssembly.addComponent buildComponent, componentName
        buildComponent.init componentAssembly


    loadJson: ( json, componentAssembly, doneCallback ) ->
        loadMonitor = []
        for entry in json
            loadMonitor[ entry.componentName ] = false
            component = @buildComponent entry.componentName, componentAssembly
            @[ "loadJson" + entry.componentName ]?.call @, entry.componentData, component, componentAssembly, ( name ) =>
                loadMonitor[ name ] = true
                allLoaded = true
                for key, value of loadMonitor
                    allLoaded = false if not value
                if allLoaded
                    doneCallback.call @, componentAssembly if doneCallback

    saveJson: ( componentAssembly ) ->
        components = componentAssembly.getComponentList()
        result = []
        for key, value of components
            method = @[ "saveJson" + key ]
            if method
                data = method.call( @, value )
                result.push
                    'componentName': key
                    'componentData': data
        result

    saveJsonLayerComponent: ( layerComponent ) ->
        result = []
        for name, layer of layerComponent.layers
            entry = {}
            entry[ "name" ] = name
            $.extend entry, BowShock.JSONSchema.Layer( layer )
            result.push entry
        result

    loadJsonLayerComponent: ( json, layerComponent, componentAssembly, doneCallback ) ->
        @onLayerComponent.call @, layerComponent if @onLayerComponent
        for l in json
            layer = layerComponent.addLayer l.name
            for key, value of l
                layer[ key ] = BowShock.JSONSchema.thaw( value )
            @onLayer?.call @, layer, l.name
        doneCallback.call @, "Layer"


    loadJsonTransformComponent: ( json, transform, componentAssembly, doneCallback ) ->
        transform.setPositionScalar  json.x,     json.y
        transform.setScaleScalar     json.width, json.height
        transform.setRotaion         json.angle
        doneCallback.call @, "Transform"


    loadJsonSpriteComponent: ( json, sprite, componentAssembly, doneCallback ) ->
        sprite.loadFile json.fileName, json.tilesX, json.tilesY, =>
            doneCallback.call @, "Sprite"


    loadJsonCollisionComponent: ( json, collision, componentAssembly, doneCallback ) ->
        for c in json
            offset   = new BowShock.Vector2 c.offsetx, c.offsety
            part     = new BowShock.Collider.RectangleCollider c.tag, c.width, c.height, offset, true
            collision.registerCollider part
        doneCallback.call @, "Collision"

