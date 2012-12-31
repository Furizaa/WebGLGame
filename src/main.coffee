manager  = null
renderer = null


init = () ->
    width  = window.innerWidth
    height = window.innerHeight
    console.log width, height

    camera = new THREE.CombinedCamera(width, height, 45, 1, 10000, -2000, 10000)
    camera.position.z = 1000

    renderer = new THREE.WebGLRenderer()
    renderer.setClearColorHex 0x333333, 1
    renderer.setSize width, height

    document.body.appendChild renderer.domElement
    $('.debugLayer').append "<div class='debug debug1'>debug1</div>"
    $('.debugLayer').append "<div class='debug debug2'>debug2</div>"
    $('.debugLayer').append "<div class='debug debug3'>debug3</div>"
    $('.debugLayer').css
        width:  width
        height: height

    BowShock.input = new BowShock.Input()
    BowShock.timer = new THREE.Clock true
    BowShock.camera = camera

    manager = new BowShock.ScreenManager renderer, camera
    screen = new BowShock.GameScreen 'game'
    manager.add screen.load()
    manager.activate screen

    window.addEventListener 'resize', onWindowResize, false


animate = () ->
    requestAnimationFrame animate
    manager.render()

update = () ->
    requestAnimationFrame update
    BowShock.delta = BowShock.timer.getDelta()
    manager.update()

onWindowResize = (event) ->
    width  = window.innerWidth
    height = window.innerHeight
    renderer.setSize width, height
    camera.aspect = width / height
    camera.updateProjectionMatrix()



init()
animate()
update()