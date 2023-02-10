function requireAll()

    require("src/utilities/utils")

    -- GAME SETTINGS
    require("src/startup/Game")
    require("src/startup/Menu")

    -- LIBRARIES
    require("libraries/anim8")
    require('libraries/windfield')

    -- MAP
    require("maps/gameMap")
    require("libraries/sti")

    -- PLAYER
    require("src/startup/Player")

    -- ENEMY
    require("src/enemy/Enemy")
    require("src/enemy/Bat")

    -- ATTACK
    require("src/effects/attack")

end
