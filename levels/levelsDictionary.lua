-- levelsDictionary.lua --

local dictionary = {
  {
    name = "shooting range",
    bounds = { -- camera boundaries
      width = 800,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 500, w = 800, h = 150, type = "ground"},
    },
    walls = {
      {x = -25, y = 75, w = 25, h = 475},
      {x = 800, y = 75, w = 25, h = 475}
    },
    zones = {
      {
        name = "targets",
        x = 0,
        y = 445,
        w = 800,
        h = 100,
        enemies = {
          {name = "target", count = 0, max = 1, side = "left", x = 100, y = 250, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "target", count = 0, max = 1, side = "left", x = 368, y = 100, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "target", count = 0, max = 1, side = "left", x = 668, y = 250, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      }
    } -- end of zones
  },

  {
    name = "level one - city",
    bounds = { -- camera boundaries
      width = 8000,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 450, w = 8000, h = 160, type = "ground"},
      {x = 1100, y = 190, w = 100, h = 10, type = "enemyPlatform"},
      {x = 1300, y = 190, w = 100, h = 10, type = "enemyPlatform"},
      {x = 1700, y = 190, w = 200, h = 10, type = "enemyPlatform"},
    },
    walls = {},
    zones = {
      {
        name = "dynamic runners",
        x = 450,
        y = 345,
        w = 2650,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1000, side = "left", x = 450, y = 380, dynamic = true, spawnTimer = 0, spawnTimerMax = 4.5},
          {name = "runner", count = 0, max = 1000, side = "right", x = -450, y = 380, dynamic = true, spawnTimer = 0, spawnTimerMax = 5.7},
        }
      },
      {
        name = "static shooter",
        x = 750,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 1155, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1300, y = 380, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "static shooter 2",
        x = 950,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 1355, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1500, y = 380, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 3, side = "right", x = 400, y = 380, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "static shooter 3",
        x = 1350,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 1745, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "static-shooter", count = 0, max = 1, side = "left", x = 1845, y = 120, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1850, y = 380, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 3, side = "right", x = 950, y = 380, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "cameras",
        x = 1850,
        y = 345,
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
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "shooter/run", count = 0, max = 1, side = "left", x = 4175, y = 380, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },
    } -- end of zones
  }, -- end of level

  {
    name = "camera test",
    bounds = { -- camera boundaries
      width = 800,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 500, w = 800, h = 150, type = "ground"},
    },
    walls = {
      {x = 800, y = 75, w = 25, h = 475}
    },
    zones = {
      {
        name = "camera turret",
        x = 0,
        y = 445,
        w = 800,
        h = 100,
        enemies = {
          {name = "camera-turret", count = 0, max = 1, side = "left", x = 150, y = 100, dynamic = false, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      }
    } -- end of zones
  }, -- end of level
} -- end of dictionary

function getLevel(levelName, level)
  for i = 1, #dictionary do
    if levelName == dictionary[i].name then
      level.name = dictionary[i].name
      level.bounds = dictionary[i].bounds
      level.ground = dictionary[i].ground
      level.walls = dictionary[i].walls
      level.zones = dictionary[i].zones
    end
  end
end

function getDictionary()
  return dictionary
end
