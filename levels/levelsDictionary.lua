-- levelsDictionary.lua --

local dictionary = {

  {
      name = "1-2",
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
            -- add the laser wall joshy
          }
        },
      } -- end of zones
  }, -- end of level

  {
    name = "1-1",
    bounds = { -- camera boundaries
      levelWidth = 2600, -- 8000
      levelHeight = 600,
      left = 0,
      top = 0
    },
    zones = {
      {
        name = "dynamic runners",
        x = 200,
        y = 45,
        w = 2000,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1000, side = "left", x = 800, y = 110, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
          {name = "runner", count = 0, max = 1000, side = "right", x = -450, y = 110, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
        }
      },
      {
        name = "static shooters",
        x = 300, --675
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 665, y = 50, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 920, y = 50, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 1100, y = 50, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 1120, y = 50, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1300, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "more runners",
        x = 650,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          --{name = "static-shooter", count = 0, max = 1, side = "left", x = 1355, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1500, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "right", x = 400, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "cameras",
        x = 1200,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 1500, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 1700, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 1900, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "cameras",
        x = 4000,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 4750, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 5000, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 5300, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 5800, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 6350, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },
      {
        name = "boss zone",
        x = 2450,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
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
    end
  end
end

function getDictionary()
  return dictionary
end
