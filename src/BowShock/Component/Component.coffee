BowShock.Component.Component = class Component

    constructor: () ->
        @parentAssembly = null

    setParentAssembly: ( parentAssembly ) ->
        @parentAssembly = parentAssembly

    resolveDependencies: ( dependencies ) ->
        for dependencyName in dependencies
            console.log "Missing dependency:", dependencyName if not @parentAssembly.getComponent( dependencyName ) and BowShock.debug
            dependency = @parentAssembly.getComponentFactory().buildComponent dependencyName, @parentAssembly
            @onResolveDependency?.call @, dependency, dependencyName if not @parentAssembly.getComponent( dependencyName )

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