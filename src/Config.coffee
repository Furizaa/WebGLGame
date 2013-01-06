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

            "level-preset": {
                scene: [
                        {
                            componentName: "LayerComponent",
                            componentData: [
                                    { name: "LY_BACKDROP", speedX: 0, speedY: 0,   visible: true, active: false },
                                    { name: "LY_PARALAX",  speedX: 5, speedY: 5,   visible: true, active: false },
                                    { name: "LY_HOT",      speedX: 10, speedY: 10, visible: true, active: true },
                                    { name: "LY_FORDERGROUND", speedX: 10, speedY: 10, visible: true, active: false }
                                ]
                        }
                    ],
                entities: [
                    [
                        {
                            componentName: "SpriteComponent",
                            componentData:      { fileName: "textures/testbox2.png" }
                        },
                        {
                            componentName: "TransformComponent",
                            componentData:      { x: 0, y: 0, width: 1000, height: 100, angle: 0 }
                        },
                        {
                            componentName: "CollisionComponent",
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