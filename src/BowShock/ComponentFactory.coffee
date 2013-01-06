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

    ###
    GENERAL
    ###

    buildComponent: ( componentName, componentAssembly, onResolveDependency ) ->
        if componentAssembly.getComponent componentName
            return componentAssembly.getComponent componentName

        if not /Component$/.test componentName then componentName += "Component"
        #console.log "BUILD", componentName if BowShock.debug
        buildComponent = new (BowShock.Component[ componentName ] || BowShock.Component.Entity[ componentName ])
        componentAssembly.addComponent buildComponent, componentName
        buildComponent.onResolveDependency = onResolveDependency
        buildComponent.init componentAssembly


    loadJson: ( json, componentAssembly, doneCallback ) ->
        loadMonitor = []
        loadMonitor[ name.componentName ] = false for name in json
        console.log "START LOADING OF ", loadMonitor
        for entry in json
            component = @buildComponent entry.componentName, componentAssembly
            @[ "loadJson" + entry.componentName ]?.call @, entry.componentData, component, componentAssembly, ( name ) =>
                loadMonitor[ name ] = true
                console.log "--- PROGRESS ", name, loadMonitor
                allLoaded = true
                for key, value of loadMonitor
                    allLoaded = false if not value
                if allLoaded
                    console.log "------- SUCCESS "
                    doneCallback?.call @, componentAssembly

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
                cloneMonitor[ name ] = true
                console.log cloneMonitor, name
                allLoaded = true
                for key, value of cloneMonitor
                    allLoaded = false if not value
                if allLoaded
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
            $.extend entry, BowShock.JSONSchema.Layer( layer )
            entry[ "entities" ] = []
            entry[ "entities" ].push( @saveJson( entity ) ) for entity in layer.entities
            result.push entry
        result

    loadJsonLayerComponent: ( json, layerComponent, componentAssembly, doneCallback ) ->
        @onLayerComponent?.call @, layerComponent
        for l in json
            layer = layerComponent.addLayer l.name
            for key, value of l
                layer[ key ] = BowShock.JSONSchema.thaw( value ) if key != "entities"
            @onLayer?.call @, layer, l.name
            for entityjson in l.entities || []
                entity = new Core.Entity.WorldEntity()
                @loadJson entityjson, entity
                layer.addEntity entity
                @onEntity?.call @, layer, entity
        doneCallback.call @, "LayerComponent"

    ###
    TRANSFORM
    ###

    saveJsonTransformComponent: ( transformComponent ) ->
        BowShock.JSONSchema.Transform transformComponent

    loadJsonTransformComponent: ( json, transform, componentAssembly, doneCallback ) ->
        transform.setPositionScalar  BowShock.JSONSchema.thaw( json.position.x ), BowShock.JSONSchema.thaw( json.position.y )
        transform.setScaleScalar     BowShock.JSONSchema.thaw( json.scale.x ), BowShock.JSONSchema.thaw( json.scale.y )
        transform.setRotaion         BowShock.JSONSchema.thaw( json.rotation )
        doneCallback.call @, "TransformComponent"

    ###
    SPRITE
    ###

    saveJsonSpriteComponent: ( spriteComponent ) ->
        BowShock.JSONSchema.Sprite spriteComponent

    loadJsonSpriteComponent: ( json, sprite, componentAssembly, doneCallback ) ->
        sprite.setTile json.tile
        sprite.loadFile json.fileName, json.tilesX, json.tilesY, =>
            @onSprite?.call @, sprite
            doneCallback.call @, "SpriteComponent"


    ###
    COLLISION
    ###

    saveJsonCollisionComponent: ( collisionComponent ) ->
        result = []
        for collider in collisionComponent.localColliders
            result.push BowShock.JSONSchema.RectCollider collider
        result

    loadJsonCollisionComponent: ( json, collisionComponent, componentAssembly, doneCallback ) ->
        @onCollisionComponent?.call @, collisionComponent
        if not json then return
        for e in json
            v = new BowShock.Vector2 BowShock.JSONSchema.thaw(e.offset.x), BowShock.JSONSchema.thaw(e.offset.y)
            collider = new BowShock.Collider.RectangleCollider e.tag, BowShock.JSONSchema.thaw(e.width), BowShock.JSONSchema.thaw(e.height), v, true
            collisionComponent.registerCollider collider
            @onCollider?.call @, collider, collisionComponent, componentAssembly
        doneCallback.call @, "CollisionComponent"
