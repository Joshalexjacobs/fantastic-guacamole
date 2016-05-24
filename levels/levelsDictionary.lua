-- levelsDictionary.lua --

local dictionary = {
  {
    name = "1-1",
    bounds = { -- camera boundaries
      levelWidth = 8000,
      levelHeight = 600,
      left = 0,
      top = 0
    },
    zones = {
      {
        name = "dynamic runners",
        x = 450,
        y = 45,
        w = 2650,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1000, side = "left", x = 800, y = 110, dynamic = true, spawnTimer = 0, spawnTimerMax = 4.5},
          {name = "runner", count = 0, max = 1000, side = "right", x = -450, y = 110, dynamic = true, spawnTimer = 0, spawnTimerMax = 5.7},
        }
      },
      {
        name = "static shooter",
        x = 750,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 1155, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1300, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "static shooter 2",
        x = 950,
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
        name = "static shooter 3",
        x = 1350,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          --{name = "static-shooter", count = 0, max = 1, side = "left", x = 1745, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          --{name = "static-shooter", count = 0, max = 1, side = "left", x = 1845, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1850, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "right", x = 950, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "cameras",
        x = 1850,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 2275, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 2675, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 3075, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },
      {
        name = "runner shooter",
        x = 3750,
        y = 45,
        w = 100,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 4175, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
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
        name = "dynamic runners",
        x = 4550,
        y = 45,
        w = 2000,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1000, side = "left", x = 800, y = 110, dynamic = true, spawnTimer = 0, spawnTimerMax = 4.5},
          {name = "runner", count = 0, max = 1000, side = "right", x = -450, y = 110, dynamic = true, spawnTimer = 0, spawnTimerMax = 5.7},
        }
      },

      {
        name = "runner shooter",
        x = 4600,
        y = 45,
        w = 300,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 5400, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "runner shooter",
        x = 4900,
        y = 45,
        w = 300,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 5700, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "runner shooter",
        x = 5200,
        y = 45,
        w = 300,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 6000, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "runner shooter",
        x = 5650,
        y = 45,
        w = 300,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 6450, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },
      {
        name = "runner shooter",
        x = 5950,
        y = 45,
        w = 300,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 6750, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },
      {
        name = "runner shooter",
        x = 6250,
        y = 45,
        w = 300,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 7050, y = 110, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
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
