-- levelsDictionary.lua --

local dictionary = {

  {
      name = "1-2",
      playerSkinV = "img/player/marine2BIG.png", -- vertical
      playerSkinH = "img/player/marineHorizontalBIG.png", -- horizontal
      tilemap = "tiled/New Level2.lua",
      startPos = 140, -- player's starting position
      bounds = { -- camera boundaries
        levelWidth = 1000, -- 8000
        levelHeight = 600,
        left = 0,
        top = 0
      },
      zones = {
        {
          name = "dynamic runners",
          x = 100,
          y = 45,
          w = 2000,
          h = 100,
          enemies = {
            {name = "runner", count = 0, max = 1000, side = "left", x = 200, y = 120, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
            {name = "runner", count = 0, max = 1000, side = "right", x = -200, y = 120, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
            --{name = "grenade", count = 0, max = 1000, side = "left", x = 400, y = 85, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
            {name = "grenade", count = 0, max = 1000, side = "right", x = 401, y = 85, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "prone-shooter", count = 0, max = 1, side = "right", x = 325, y = 160, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "laser-wall", count = 0, max = 1, side = "right", x = 150, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "wizard", count = 0, max = 1, side = "left", x = 500, y = 17, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2}, -- x = 190
            --{name = "wizard", count = 0, max = 1, side = "right", x = 550, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "gSlime", count = 0, max = 1, side = "left", x = 550, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "gSlime", count = 0, max = 1, side = "left", x = 380, y = 140, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "cSlime", count = 0, max = 1, side = "left", x = 380, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "cSlime", count = 0, max = 1, side = "left", x = 420, y = 0, dynamic = false, spawnTimer = 1, spawnTimerMax = 2.5},
            {name = "cSlime", count = 0, max = 1, side = "left", x = 460, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
          }
        },
      } -- end of zones
  }, -- end of level

  {
      name = "wall turret",
      playerSkinV = "img/player/marine2BIG.png", -- vertical
      playerSkinH = "img/player/marineHorizontalBIG.png", -- horizontal
      tilemap = "tiled/New Level2.lua",
      startPos = 740, -- player's starting position
      bounds = { -- camera boundaries
        levelWidth = 1000, -- 8000
        levelHeight = 600,
        left = 0,
        top = 0
      },
      zones = {
        {
          name = "wall turret",
          x = 100,
          y = 45,
          w = 2000,
          h = 100,
          enemies = {
            {name = "turret-wall", count = 0, max = 1, side = "right", x = 985, y = 5, dynamic = false, spawnTimer = 0, spawnTimerMax = 3}
          }
        },
      } -- end of zones
  }, -- end of level

  {
      name = "tutorial",
      playerSkinV = "img/player/matrix player.png", -- vertical
      playerSkinH = "img/player/matrix prone.png", -- horizontal
      tilemap = "tiled/matrix.lua",
      startPos = 140, -- player's starting position
      bounds = { -- camera boundaries
        levelWidth = 1000, -- 8000
        levelHeight = 600,
        left = 0,
        top = 0
      },
      zones = {
        {
          name = "empty",
          x = 100,
          y = 45,
          w = 2000,
          h = 100,
          enemies = {
            --{name = "turret-wall", count = 0, max = 1, side = "right", x = 985, y = 5, dynamic = false, spawnTimer = 0, spawnTimerMax = 3}
          }
        },
      } -- end of zones
  }, -- end of level

} -- end of dictionary

function getLevel(levelName, level)
  for i = 1, #dictionary do
    if levelName == dictionary[i].name then
      level.name = dictionary[i].name
      level.bounds = dictionary[i].bounds
      level.zones = dictionary[i].zones
      level.playerSkinV = dictionary[i].playerSkinV
      level.playerSkinH = dictionary[i].playerSkinH
      level.tilemap = dictionary[i].tilemap
      level.startPos = dictionary[i].startPos
    end
  end
end

function getDictionary()
  return dictionary
end
