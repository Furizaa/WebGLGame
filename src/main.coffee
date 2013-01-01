game = null

init = () ->
    game = new BowShock.Game().init();
    window.addEventListener 'resize', onWindowResize, false

render = () ->
    requestAnimationFrame render
    game.render()

update = () ->
    requestAnimationFrame update
    game.update()

onWindowResize = (event) ->
    game.onResize()


init()
render()
update()