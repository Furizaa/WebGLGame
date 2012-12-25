BowShock.PlayerEntity = class PlayerEntity

    constructor: () ->

    load: (done) ->
        geometry = new THREE.CubeGeometry 200, 200, 200
        material = new THREE.MeshBasicMaterial
            color: 0x900909
            wireframe: true
        @mesh = new THREE.Mesh geometry, material
        done()
        @

    update: (input) ->
        @mesh.rotation.x += 0.01 if input.isKeyPressed BowShock.Input.KEY_UP
        @mesh.rotation.y += 0.01 if input.isKeyPressed BowShock.Input.KEY_LEFT
        @

    bind: (scene) ->
        console.log scene
        scene.add @mesh
        @
