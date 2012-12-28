BowShock.Screen = class Screen

    active: false

    entities: []

    constructor: (@name) ->
        @spriteBatch = new THREE.Scene()

    addEntity: (reference, entity) ->
        @entities[ reference ] = entity if not @entities[ reference ]

    getEntity: (name) ->
        @entities[ name ]

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

    activate: () ->
        @active = true

    deactivate: () ->
        @active = false

