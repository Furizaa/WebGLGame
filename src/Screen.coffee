BowShock.Screen = class Screen

    constructor: (@name) ->
        @spriteBatch = new BowShock.SpriteBatch()
        @active = false
        @loaded = false
        @entities = []
        @count = 0

    addEntity: (reference, entity) ->
        console.log entity, reference
        if not @entities[ reference ]
            @entities[ reference ] = entity
            @count++

    getEntity: (name) ->
        @entities[ name ]

    getEntityCount: () ->
        @count

    getName: () ->
        @name

    load: () ->
        for ref, entity of @entities
            entity.init @spriteBatch

    unload: () ->
        entity.unload() for ref, entity of @entities when entity.isLoaded()

    update: () ->
        if @isActive()
            entity.update() for ref, entity of @entities when entity.isLoaded()

    render: (renderer, camera) ->
        @spriteBatch.render renderer, camera
        @

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

