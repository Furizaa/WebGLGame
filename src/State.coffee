BowShock.State = class State

    active: false

    entities: []

    constructor: (@name, @input) ->
        @scene = new THREE.Scene()

    addEntitie: (reference, entity) ->
        @entities[ reference ] = entity if not @entities[ reference ]
        console.log @entities

    load: () ->
        scene = @scene
        for ref, entity of @entities
            entity.load -> entity.bind scene

    unload: () ->
        entity.unload() for ref, entity of @entities

    update: () ->
        if @isActive()
            entity.update(@input) for ref, entity of @entities

    getScene: () ->
        @scene

    isActive: () ->
        @active

    activate: () ->
        @active = true

    deactivate: () ->
        @active = false

