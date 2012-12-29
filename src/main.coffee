manager = null

init = () ->
    width  = 1280
    height = 800

    camera = new THREE.OrthographicCamera( width / - 2, width / 2, height / 2, height / - 2, 1, 1000 )
    camera.position.z = 1500

    renderer = new THREE.WebGLRenderer()
    renderer.setClearColorHex 0x333333, 1
    renderer.setSize width, height

    document.body.appendChild renderer.domElement

    BowShock.input = new BowShock.Input()
    BowShock.timer = new THREE.Clock true

    manager = new BowShock.ScreenManager renderer, camera
    screen = new BowShock.GameScreen 'game'
    manager.add screen.load()
    manager.activate screen


animate = () ->
    requestAnimationFrame animate
    manager.render()

update = () ->
    requestAnimationFrame update
    BowShock.delta = BowShock.timer.getDelta()
    manager.update()

init()
animate()
update()