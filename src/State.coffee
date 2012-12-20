window.State = class State

    active: false

    constructor: (@name, @input) ->
        @scene = new THREE.Scene()

    load: () ->
        geometry = new THREE.CubeGeometry 200, 200, 200
        material = new THREE.MeshBasicMaterial
            color: 0xff00f0
            wireframe: true
        @mesh = new THREE.Mesh geometry, material
        @scene.add @mesh
        @

    update: () ->
        @mesh.rotation.x += 0.01 if @input.state.jump
        @mesh.rotation.y += 0.01

    getScene: () =>
        @scene

    isActive: () =>
        @active

    activate: () ->
        @active = true

    deactivate: () ->
        @active = false

