-- levelsDictionary.lua --

local dictionary = {
  {
    name = "test001",
    bounds = { -- camera boundaries
      width = 5000,
      height = 600, -- at minimum should be equal to windowHeight
      left = 0,
      top = 0
    },
    ground = { -- will eventually be an array of ground types
      {x = 0, y = 450, w = 1000, h = 160}
    },
    walls = {},
    zones = {
      {x = 450, y = 345, w = 200, h = 100, enemies = {"runner"}},
      {x = 700, y = 345, w = 200, h = 100, enemies = {"runner"}}
    }
  },

  {
    name = "test002",
    bounds = { -- camera boundaries
      width = 5000,
      height = 600, -- at minimum should be equal to windowHeight
      left = 0,
      top = 0
    },
    ground = { -- will eventually be an array of ground types
      {x = 0, y = 450, w = 700, h = 160},
      {x = 850, y = 450, w = 700, h = 160},
    },
    walls = {},
    zones = {
      {x = 950, y = 345, w = 200, h = 100, enemies = {"runner"}}
    }
  },

  {
    name = "shooting range",
    bounds = { -- camera boundaries
      width = 800,
      height = 600, -- at minimum should be equal to windowHeight
      left = 0,
      top = 0
    },
    ground = { -- will eventually be an array of ground types
      {x = 0, y = 550, w = 800, h = 150},
    },
    walls = {
      {x = -25, y = 75, w = 25, h = 475},
      {x = 800, y = 75, w = 25, h = 475},
    },
    zones = {
    }
  }

}

function getLevel(levelName)
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
