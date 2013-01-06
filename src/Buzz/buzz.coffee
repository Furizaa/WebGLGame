window.Buzz = class Buzz

    constructor: ( @droot ) ->
        @$root = $ '<div/>'
        @$root.appendTo( $ @droot ).attr id: 'buzz'
        @

    addContainer: ( desc ) ->
        new Buzz.ContainerController @$root, desc

    @ColorPointer: 0
    @Colors: [ '#ffffff', '#ffffff', '#ffffff', '#ffffff', '#ffffff' ,'#ffffff' ]

    @Template:
        Container: '
            <div class="container">
                <div class="item">
                    <h3/>
                </div>
            </div>
        '
        Button: '
            <div class="item btn Button">
                <i class="icon-cogs" />
                <span />
            </div>
        '
        Switch: '
            <div class="item Switch">
                <i class="" />
                <span />
            </div>
        '
        Radio: '
            <div class="item Radio">
                <i class="icon-circle-blank" />
                <span />
            </div>
        '
        Text: '
            <div class="item Text">
                <span />
                <input type="text" class="string" />
            </div>
        '
        Number: '
            <div class="item Number">
                <span />
                <input type="text" />
            </div>
        '
        Bar: '
            <div class="item Bar">
                <span />
                <input type="text" />
                <div class="Bar">
                    <div />
                </div>
            </div>
        '
        Select: '
            <div class="item Select">
                <span />
                <select />
            </ div>
        '

###
Abstract Controller
###
class Buzz.Controller

    constructor: ( @parent, @$el ) ->
        @$el.appendTo @parent
        @$el.data 'controller', @
        @$el.addClass( 'color' + Buzz.ColorPointer )

    remove: () ->
        @onRemove.call @ if @onRemove
        @$el.off()
        @$el.remove()

    onChange: ( @_onChange, @_onChangeParams = []) ->

    setValue: ( @value ) ->
        @?._update( @value )
        @

###
Abstract Input Controller
###
class Buzz.InputController extends Buzz.Controller

    constructor: ( @parent, @$el ) ->
        super @parent, @$el
        @$text = @$el.children( 'input' )
        @$text.on 'change', =>
            @value = @$text.attr('value')
            @_update()
        @$text.on 'blur', =>
            @_onChange?.call @, @value, @_onChangeParams
        @$text.on 'keyup', (event) =>
            if event.keyCode == 13 then @$text.trigger('blur')

###
Button Controller
###
class Buzz.ButtonController extends Buzz.Controller

    constructor: ( @parent, desc, @$el ) ->
        @$el.children( 'span' ).text desc
        super @parent, @$el

    onClick: ( @_onClick, @_onClickParams = [] ) ->
        @$el.on 'click', =>
            @_onClick?.call @, @_onClickParams
        @

###
Switch Controller
###
class Buzz.SwitchController extends Buzz.Controller

    constructor: ( @parent, desc, @$el ) ->
        @value = false
        @$el.children('span').text desc
        @$icon = @$el.children('i')
        super @parent, @$el
        @$el.on 'click', =>
            @value = not @value
            @_update()
            @_onChange?.call @, @value, @_onChangeParams
        @_update()

    _update: () =>
        if @value
            @$icon.removeClass('icon-check-empty').addClass('icon-check')
        else
            @$icon.removeClass('icon-check').addClass('icon-check-empty')
        @

###
Radio Controller
###
class Buzz.RadioController extends Buzz.Controller

    constructor: ( @parent, @desc, @$el ) ->
        @value = false
        @$el.children('span').text @desc
        @$icon = @$el.children('i')
        super @parent, @$el
        @$el.on 'click', =>
            if @value is true then return
            @value = true
            @_update()
        @

    _update: () =>
        @$icon.removeClass('icon-circle-blank').addClass('icon-circle') if @value
        @$icon.removeClass('icon-circle').addClass('icon-circle-blank') if not @value
        if @value is true
            self = @
            $.each @parent.children('div.Radio'), ->
                controller = $( @ ).data('controller')
                if controller.desc != self.desc
                    controller.setValue( false )
                    controller._onChange?.call @, @, @value
        @_onChange?.call @, @, @value, @_onChangeParams
        @

###
TextController
###
class Buzz.TextController extends Buzz.InputController

    constructor: ( @parent, desc, @$el ) ->
        @value = ""
        @$el.children('span').text desc
        super @parent, @$el

    _update: () ->
        if typeof @value != "string" then @value = ""
        @$text.attr 'value', @value
        @

###
NumberController
###
class Buzz.NumberController extends Buzz.TextController

    _update: () ->
        if typeof @value != "number" then @value = ""
        @value = Math.max( @_min, Math.min( @_max, @value ) ) #Clamp
        @$text.attr 'value', @value
        @

    min:  ( @_min ) -> @_update()
    max:  ( @_max ) -> @_update()

###
BarController
###
class Buzz.BarController extends Buzz.InputController

    constructor: ( @parent, desc, @$el ) ->
        @value  = @_min = @_max = 0
        @_step  = 1
        @$el.children('span').text desc
        super @parent, @$el
        $bar    = @$el.children('div')
        @$fill   = $bar.children('div')
        @$text   = @$el.children('input')
        $clickX = 0
        @_update()
        $bar.on 'mousedown', (event) =>
            $clickX = event.screenX
            $(window).on 'mouseup', (event) =>
                $(window).off 'mouseup mousemove'
            $(window).on 'mousemove', (event) =>
                event.preventDefault()
                offset  = event.screenX - $clickX
                $clickX = event.screenX
                @value =  @value + offset * @_step
                @_update()
                @_onChange?.call @, @value, @_onChangeParams

    _update: () ->
        if typeof @value != "number" then parseInt( @value, 10 )
        @value = Math.max( @_min, Math.min( @_max, @value ) ) #Clamp
        @$fill.css width: ((100 / (@_max-@_min) * (@value-@_min)) + "%")
        @$text.attr 'value', @value
        @

    min:  ( @_min ) -> @_update()
    max:  ( @_max ) -> @_update()
    step: ( @_step ) -> @_update()

###
Select Controller
###
class Buzz.SelectController extends Buzz.Controller

    constructor: ( @parent, desc, @$el ) ->
        @value = undefined
        @$el.children('span').text desc
        @$select = @$el.children( 'select' );
        super @parent, @$el
        @$el.on 'change', =>
            @_onChange?.call @, @$select.val(), @_onChangeParams

    options: ( opts ) ->
        for opt in opts
            $opt = $( '<option />' ).attr( 'value', opt ).text( opt )
            $opt.appendTo @$el.children( 'select' )
        @value = @$select.val() if not @value
        @

    _update: () ->
        @$select.val( @value )
        @

###
Container
###
class Buzz.ContainerController extends Buzz.Controller

    constructor: ( @parent, desc ) ->
        @$el = $ Buzz.Template.Container
        @$el.find( 'h3' ).text desc
        super @parent, @$el
        Buzz.ColorPointer++
        @

    addController: ( type, desc ) ->
        type = type.charAt( 0 ).toUpperCase() + type.toLowerCase().slice( 1 )
        el  = Buzz.Template[ type ]
        fn   = Buzz[ type + "Controller" ]
        if el and fn then return new fn @$el, desc, $( el )
        undefined

    clear: ( type ) ->
        @$el.children('.item:not(:first-child)').remove() if type is undefined
        @$el.children('.' + type).remove() if type
        @

    remove: () ->
        @clear( 'item' )
        @$el.remove()







