BowShock.LoadingMonitor = class LoadingMonitor

    constructor: () ->
        @reset()

    register: ( call, context, args... ) ->
        newcall =
            call: call
            args: args
            done: false
        @registered.push newcall
        call.call context, args..., =>
            newcall.done = true

    getProgress: () ->
        loaded  = 0
        count = @getCount()
        return 0 if count is 0

        for loader in @registered
            if loader.done is true  then loaded++
        return Math.round( (100 / @getCount()) * loaded )

    getCount: () ->
        @registered.length

    reset: () ->
        @registered = []

    onFinish: (callback) ->
        if @getProgress() == 100
            callback.call @
            return @
        window.setTimeout( =>
            @onFinish( callback )
        , 500 )

