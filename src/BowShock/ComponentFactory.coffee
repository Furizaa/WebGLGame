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
        @monitor = new BowShock.LoadingMonitor()
        @JSON = BowShock.JSONSchema

    getMonitor: () ->
        @monitor

    ###
    GENERAL
    ###

    buildComponent: ( componentName, componentAssembly, onResolveDependency ) ->
        if componentAssembly.getComponent componentName
            return componentAssembly.getComponent componentName

        buildComponent = new (BowShock.Component[ componentName ] || BowShock.Component.Entity[ componentName ])
        componentAssembly.addComponent buildComponent, componentName
        buildComponent.onResolveDependency = onResolveDependency
        buildComponent.init componentAssembly


    loadJson: ( json, componentAssembly, doneCallback ) ->
        for entry in json
            component = @buildComponent entry.componentName, componentAssembly
            method    = @[ "loadJson" + entry.componentName ]
            @monitor.register method, @, entry.componentData, component, componentAssembly


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


    clone: ( assembly, doneCallback ) ->
        clone = assembly.clone().reset()
        cloneMonitor = []
        cloneMonitor[ name ] = false for name, c of assembly.getComponentList()
        for name, component of assembly.getComponentList()
            component.clone clone, ( componentClone, name ) ->
                clone.addComponent componentClone, name
                doneCallback?.call @, clone
        clone

    ###
    LAYER
    ###

    saveJsonLayerComponent: ( layerComponent ) ->
        result = []
        for name, layer of layerComponent.layers
            entry = {}
            entry[ "name" ] = name
            $.extend entry, @JSON.serializeLayer( layer )
            entry[ "entities" ] = []
            entry[ "entities" ].push( @saveJson( entity ) ) for entity in layer.entities
            result.push entry
        result

    loadJsonLayerComponent: ( json, layerComponent, componentAssembly, doneCallback ) ->
        @onLayerComponent?.call @, layerComponent
        for l in json
            layer = layerComponent.addLayer l.name
            for key, value of l
                layer[ key ] = @JSON.thaw( value ) if key != "entities"
            @onLayer?.call @, layer, l.name
            for entityjson in l.entities || []
                entity = new Core.Entity.WorldEntity()
                @loadJson entityjson, entity
                layer.addEntity entity
                @onEntity?.call @, layer, entity
        doneCallback.call @,

    ###
    TRANSFORM
    ###

    saveJsonTransformComponent: ( transformComponent ) ->
        @JSON.serializeTransform transformComponent

    loadJsonTransformComponent: ( json, transform, componentAssembly, doneCallback ) ->
        transform.setPositionScalar  @JSON.thaw( json.position.x ), @JSON.thaw( json.position.y )
        transform.setScaleScalar     @JSON.thaw( json.scale.x ), @JSON.thaw( json.scale.y )
        transform.setRotaion         @JSON.thaw( json.rotation )
        doneCallback.call @

    ###
    SPRITE
    ###

    saveJsonSpriteComponent: ( spriteComponent ) ->
        @JSON.serializeSprite spriteComponent

    loadJsonSpriteComponent: ( json, sprite, componentAssembly, doneCallback ) ->
        sprite.setTile json.tile
        sprite.loadFile json.fileName, json.tilesX, json.tilesY, =>
            @onSprite?.call @, sprite
            doneCallback.call @


    ###
    COLLISION
    ###

    saveJsonCollisionComponent: ( collisionComponent ) ->
        result = []
        for collider in collisionComponent.localColliders
            result.push @JSON.serializeRectCollider collider
        result

    loadJsonCollisionComponent: ( json, collisionComponent, componentAssembly, doneCallback ) ->
        @onCollisionComponent?.call @, collisionComponent
        if not json then return
        for e in json
            v = @JSON.deSerializeVector2 e.offset
            collider = new BowShock.Collider.RectangleCollider e.tag, @JSON.thaw(e.width), @JSON.thaw(e.height), v, true
            collisionComponent.registerCollider collider
            @onCollider?.call @, collider, collisionComponent, componentAssembly
        doneCallback.call @
