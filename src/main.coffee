manager = null

init = () ->
    camera = new THREE.PerspectiveCamera( 75, 800 / 600, 1, 10000 )
    camera.position.z = 1000

    renderer = new THREE.WebGLRenderer()
    renderer.setClearColorHex 0x333333, 1
    renderer.setSize 800, 600

    document.body.appendChild renderer.domElement

    input = new BowShock.Input()
    manager = new BowShock.StateManager renderer, camera
    state = new BowShock.StateLevel 'cube', input
    manager.add state.load()
    manager.activate state


animate = () ->
    requestAnimationFrame animate
    manager.render()

update = () ->
    requestAnimationFrame update
    manager.update()

init()
animate()
update()