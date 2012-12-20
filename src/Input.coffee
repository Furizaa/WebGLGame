window.Input = class Input

    constructor: () ->
        document.addEventListener 'keydown', @onKeyDown, false
        document.addEventListener 'keyup', @onKeyUp, false

    state:
        jump: false

    onKeyDown: ( event ) =>
        switch event.keyCode
            when 38 then @state.jump = true

    onKeyUp: ( event ) =>
        switch event.keyCode
            when 38 then @state.jump = false