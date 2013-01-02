Core.Scene.EditorScene = class EditorScene extends BowShock.Scene

    constructor: () ->
        super()
        return @
        @gui            = new dat.GUI();
        @loader         = new BowShock.LevelLoader @
        @file           = "unsaved.json"
        @gridX          = 32
        @gridY          = 32
        @newEntityType  = "ET_WORLD"
        @layerCache     = {}

    load: ( doneCallback ) ->
        super doneCallback
        return
        @factory         = @getComponentFactory()
        @factory.onLayer = @onLoadLayer

        @gui.add @, "file"
        @gui.add @, "save"
        @gui.add( @, "gridX" ).min( 8 ).max( 128 ).step( 8 )
        @gui.add( @, "gridY" ).min( 8 ).max( 128 ).step( 8 )
        @gui.add( @, "newEntityType", [ 'ET_WORLD' ] )
        @gui.add( @, "createEntity" )

        @folderLayers = @gui.addFolder "Layer"

        @loader.load BowShock.Config.instance().get()[ "level-preset" ]


    onLoadLayer: ( layer, name ) =>
        folder = @folderLayers.addFolder name
        folder.add( layer, "speedX"  ).min( 0 ).max( 50 ).step( 1 )
        folder.add( layer, "speedY"  ).min( 0 ).max( 50 ).step( 1 )
        folder.add( layer, "visible" )
        folder.add( layer, "active" )

    createEntity: () ->
        entity = new Core.Entity.WorldEntity()
        @selectEntity entity

    selectEntity: ( entity ) ->
        if not @entityFolder
            @entityFolder    = @gui.addFolder "Entity"
            @spriteFolder    = @entityFolder.addFolder "Sprite"
            @transformFolder = @entityFolder.addFolder "Transform"

            sprite = entity.getComponent "Sprite"
            @spriteFolder.add sprite, "fileName"

            transform = entity.getComponent "Transform"
            @transformFolder.add transform.getPosition(), "x"
            @transformFolder.add transform.getPosition(), "y"



    save: () ->

