-- levelsDictionary.lua --

local dictionary = {
  {
    name = "test001",
    bounds = { -- camera boundaries
      width = 5000,
      height = windowHeight, -- at minimum should be equal to windowHeight
      left = 0,
      top = 0
    },
    ground = { -- will eventually be an array of ground types
      x = 0,
      y = 450,
      w = 5000,
      h = 160
    },
    zones = {
      {x = 450, y = 345, w = 200, h = 100, enemies = {"runner"}},
      {x = 700, y = 345, w = 200, h = 100, enemies = {"runner"}}
    }
  },

  {
    name = "test002",
    bounds = { -- camera boundaries
      width = 5000,
      height = windowHeight, -- at minimum should be equal to windowHeight
      left = 0,
      top = 0
    },
    ground = { -- will eventually be an array of ground types
      {x = 0, y = 450, w = 700, h = 160},
      {x = 850, y = 450, w = 500, h = 160},
    },
    zones = {
      {x = 950, y = 345, w = 200, h = 100, enemies = {"runner"}}
    }
  }
}

function getLevel(levelName)
  for i = 1, #dictionary do
    if levelName == dictionary[i].name then
      level.name = dictionary[i].name
      level.bounds = dictionary[i].bounds
      level.ground = dictionary[i].ground
      level.zones = dictionary[i].zones
    end
  end
end
