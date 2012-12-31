BowShock.Screen = class Screen

    active: false

    loaded: false

    entities: []

    constructor: (@name) ->
        @spriteBatch = new THREE.Scene()
        @count = 0

    addEntity: (reference, entity) ->
        if not @entities[ reference ]
            @entities[ reference ] = entity
            @count++

    getEntity: (name) ->
        @entities[ name ]

    getEntityCount: () ->
        @count

    load: () ->
        for ref, entity of @entities
            entity.init()

    unload: () ->
        entity.unload() for ref, entity of @entities

    update: () ->
        if @isActive()
            entity.update() for ref, entity of @entities

    getSpriteBatch: () ->
        @spriteBatch

    isActive: () ->
        @active

    isLoaded: () ->
        @loaded

    activate: () ->
        @active = true

    deactivate: () ->
        @active = false

