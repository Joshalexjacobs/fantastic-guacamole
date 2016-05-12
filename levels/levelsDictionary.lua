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
      {x = 0, y = 450, w = 700, h = 160},
      {x = 850, y = 320, w = 700, h = 350}
    },
    walls = {},
    zones = {
      {
        x = 450,
        y = 345,
        w = 200,
        h = 100,
        enemies = {
          {name = "runner", x = nil, y = nil, max = 3}
        }
      },

      {
        x = 1100,
        y = 215,
        w = 200,
        h = 100,
        enemies = {
          {name = "runner", x = nil, y = nil, max = 3}
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
      {x = 0, y = 550, w = 800, h = 150},
    },
    walls = {
      {x = -25, y = 75, w = 25, h = 475},
      {x = 800, y = 75, w = 25, h = 475}
    },
    zones = {
      {
        x = 0,
        y = 445,
        w = 800,
        h = 100,
        enemies = {
          {name = "target", x = 100, y = 250, max = 1},
          {name = "target", x = 368, y = 100, max = 1},
          {name = "target", x = 668, y = 250, max = 1}
        }
      }
    } -- end of zones
  },

  {
    name = "shooter-run test level",
    bounds = { -- camera boundaries
      width = 5000,
      height = 600,
      left = 0,
      top = 0
    },
    ground = {
      {x = 0, y = 450, w = 1200, h = 160},
      --{x = 600, y = 250, w = 700, h = 50}
    },
    walls = {},
    zones = {
      {
        x = 450,
        y = 345,
        w = 300,
        h = 100,
        enemies = {
          {name = "shooter/run", x = nil, y = nil, max = 2}
        }
      }
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
