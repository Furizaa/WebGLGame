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
                            component: "Sprite",
                            data:      { fileName: "textures/testbox2.png" }
                        },
                        {
                            component: "Transform",
                            data:      { x: -50, y: -50, width: 100, height: 100, angle: 0 }
                        }
                    ],
                    [
                        {
                            component: "Sprite",
                            data:      { fileName: "textures/testbox2.png" }
                        },
                        {
                            component: "Transform",
                            data:      { x: 50, y: 50, width: 100, height: 100, angle: 0 }
                        }
                    ]

                ]
            }
        }
        `
        null