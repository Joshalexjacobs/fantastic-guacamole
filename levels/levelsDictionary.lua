-- levelsDictionary.lua --

local dictionary = {
  {
    name = "test level 1",
    bounds = { -- camera boundaries
      width = 5000,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 450, w = 900, h = 160},
      {x = 1050, y = 320, w = 700, h = 350}
    },
    walls = {},
    zones = {
      {
        name = "josh",
        x = 450,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1, side = "left", x = 850, y = 380, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },

      {
        name = "jacobs",
        x = 1100,
        y = 215,
        w = 200,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1, side = "left", x = 1650, y = 250, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      }
    } -- end of zones
  },

  {
    name = "shooting range",
    bounds = { -- camera boundaries
      width = 800,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 500, w = 800, h = 150},
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
          {name = "target", count = 0, max = 1, side = "left", x = 100, y = 250, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "target", count = 0, max = 1, side = "left", x = 368, y = 100, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "target", count = 0, max = 1, side = "left", x = 668, y = 250, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      }
    } -- end of zones
  },

  {
    name = "level one - city",
    bounds = { -- camera boundaries
      width = 5000,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 450, w = 6000, h = 160},
    },
    walls = {},
    zones = {
      {
        name = "first runner",
        x = 450,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1, side = "left", x = 900, y = 380, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },
      {
        name = "two runners",
        x = 700,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1, side = "right", x = 250, y = 380, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1000, y = 380, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },


    } -- end of zones
  },
  {
    name = "16:9",
    bounds = { -- camera boundaries
      width = 5000,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 325, w = 6000, h = 160},
    },
    walls = {},
    zones = {
      {
        name = "first runner",
        x = 450,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1, side = "left", x = 900, y = 380, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },
      {
        name = "two runners",
        x = 700,
        y = 345,
        w = 100,
        h = 100,
        enemies = {
          {name = "runner", count = 0, max = 1, side = "right", x = 250, y = 380, spawnTimer = 0, spawnTimerMax = 0.8},
          {name = "runner", count = 0, max = 1, side = "left", x = 1000, y = 380, spawnTimer = 0, spawnTimerMax = 0.8},
        }
      },


    } -- end of zones
  },
}

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
