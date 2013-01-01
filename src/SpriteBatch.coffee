BowShock.SpriteBatch = class SpriteBatch

    constructor: () ->
        @list  = []
        @scene = new THREE.Scene()

    getScene: () ->
        @scene

    render: (renderer, camera) ->
        @_applyCamera(sprite, camera) for sprite in @list
        renderer.render @scene, camera.tcamera

    add: (object) ->
        @list.push object
        @scene.add object.tsprite

    _applyCamera: (sprite, camera) ->
        sprite.tsprite.position.x = sprite.getPosition().x + camera.x
        sprite.tsprite.position.y = sprite.getPosition().y + camera.y

