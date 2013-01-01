manager  = null
renderer = null
camera   = null


init = () ->

    renderer = new THREE.WebGLRenderer()
    renderer.setClearColorHex 0x333333, 1
    renderer.setSize BowShock.width, BowShock.height
    renderer.autoClear = false

    document.body.appendChild renderer.domElement
    $('.debugLayer').append "<div class='debug debug1'>debug1</div>"
    $('.debugLayer').append "<div class='debug debug2'>debug2</div>"
    $('.debugLayer').append "<div class='debug debug3'>debug3</div>"
    $('.debugLayer').css
        width:  BowShock.width
        height: BowShock.height

    BowShock.input = new BowShock.Input()
    BowShock.timer = new THREE.Clock true
    BowShock.spriteCam = new BowShock.Camera BowShock.width, BowShock.height

    BowShock.manager = new BowShock.ScreenManager renderer, BowShock.spriteCam
    game = new BowShock.GameScreen 'game'
    edit = new BowShock.EditorScreen 'editor'

    BowShock.manager.add game.load()
    BowShock.manager.add edit.load()

    BowShock.manager.activate game

    window.addEventListener 'resize', onWindowResize, false


animate = () ->
    requestAnimationFrame animate
    BowShock.manager.render()

update = () ->
    requestAnimationFrame update
    BowShock.input.update()
    BowShock.delta = BowShock.timer.getDelta()
    BowShock.manager.update()

onWindowResize = (event) ->
    width  = window.innerWidth
    height = window.innerHeight
    renderer.setSize width, height
    camera.aspect = width / height
    camera.updateProjectionMatrix()



init()
animate()
update()