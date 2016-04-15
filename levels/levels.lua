-- levels.lua --

-- levels.lua is used to load and generate levels by adding zones w/ enemies to a flat block which
-- will be the type "ground" at some point in the future.

level = {
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
  }
}

levels = {}

function loadLevel(world)
  --for i = 1, #level.ground do
    addBlock(level.ground.x, level.ground.y, level.ground.w, level.ground.h, world, "ground") -- floor/ love.graphics.getHeight() - 150
  --end
end
