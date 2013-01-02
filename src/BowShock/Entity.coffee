BowShock.Entity = class Entity extends BowShock.Component.ComponentAssembly

    constructor: () ->
        super()
        @loaded    = false
        @transform = @getComponentFactory().buildComponent "Transform", @

    load: () ->
        @loaded = true

    loadJson: ( json, doneCallback ) ->
        @monitor = []
        for component in json
            @monitor[ component.component ] = false
            cobject = @getComponentFactory().buildComponent component.component, @
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

    isLoaded: () -> @loaded