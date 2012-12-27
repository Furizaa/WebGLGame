manager = null

init = () ->
    camera = new THREE.PerspectiveCamera( 60, 800 / 600, 1, 2100 )
    camera.position.z = 1500

    renderer = new THREE.WebGLRenderer()
    renderer.setClearColorHex 0x333333, 1
    renderer.setSize 800, 600

    document.body.appendChild renderer.domElement

    BowShock.input = new BowShock.Input()
    BowShock.timer = new THREE.Clock true

    manager = new BowShock.StateManager renderer, camera
    state = new BowShock.StateLevel 'level'
    manager.add state.load()
    manager.activate state


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