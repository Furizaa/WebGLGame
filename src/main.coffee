manager = null

init = () ->
    camera = new THREE.OrthographicCamera( 800 / - 2, 800 / 2, 600 / 2, 600 / - 2, 1, 1000 )
    camera.position.z = 1500

    renderer = new THREE.WebGLRenderer()
    renderer.setClearColorHex 0x333333, 1
    renderer.setSize 800, 600

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