BowShock.Config = class Config

    _instance = undefined

    @instance: () ->
        _instance ?= new BowShock._Config()

BowShock._Config = class _Config

    get: () ->
        `
        return {
            screen: {
                width:  window.innerWidth,
                height: window.innerHeight
            },

            "level0": {
                entities: [

                    [
                        {
                            componentName: "Sprite",
                            componentData:      { fileName: "textures/testbox2.png" }
                        },
                        {
                            componentName: "Transform",
                            componentData:      { x: 0, y: 0, width: 1000, height: 100, angle: 0 }
                        },
                        {
                            componentName: "Collision",
                            componentData: [
                                { tag: "CT_WORLD", width: 1000, height: 100, offsetx: 0, offsety: 0 }
                            ]
                        }
                    ]

                ]
            }
        }
        `
        null