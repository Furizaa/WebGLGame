BowShock.Entity = class Entity

    constructor: () ->
        @loaded    = false
        @assembly  = new BowShock.Component.ComponentAssembly()
        @transform = @assembly.addComponent( "Transform" ).init( @ )

    load: () ->
        @loaded = true

    loadJson: ( json, doneCallback ) ->
        @monitor = []
        for component in json
            @monitor[ component.component ] = false
            cobject = @assembly.addComponent( component.component ).init()
            cobject.loadJson component.data, (name) =>
                @monitor[ name ] = true
                allLoaded = true
                for key, value of @monitor
                    allLoaded = false if not value
                if allLoaded
                    @loaded = true
                    doneCallback.call @, @ if doneCallback
        @

    saveJson: () ->
        #todo

    getComponent: ( component ) ->
        @assembly._( component )

    update: ( delta ) ->
        @assembly.updateComponents delta

    isLoaded: () -> @loaded