BowShock.Component.Component = class Component

    constructor: () ->
        @parentAssembly = null

    setParentAssembly: ( parentAssembly ) ->
        @parentAssembly = parentAssembly

    resolveDependencies: ( dependencies ) ->
        for dependency in dependencies
            console.log "Missing dependency:", dependency if not @parentAssembly._( dependency ) and BowShock.debug
            @parentAssembly.addComponent( dependency ).init()

    getDependencyComponent: ( dependency ) ->
        @parentAssembly._( dependency )

    # Overwrite
    init: () ->
        @resolveDependencies @dependencies
        @

    # Overwrite
    reset: () ->

    # Overwrite
    loadJson: () ->

    # Overwrite
    saveJson: () ->