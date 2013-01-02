BowShock.Component.Component = class Component

    constructor: () ->
        @parentAssembly = null

    setParentAssembly: ( parentAssembly ) ->
        @parentAssembly = parentAssembly

    resolveDependencies: ( dependencies ) ->
        for dependency in dependencies
            console.log "Missing dependency:", dependency if not @parentAssembly.getComponent( dependency ) and BowShock.debug
            @parentAssembly.getComponentFactory().buildComponent dependency, @parentAssembly

    getDependencyComponent: ( dependency ) ->
        @parentAssembly.getComponent( dependency )

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