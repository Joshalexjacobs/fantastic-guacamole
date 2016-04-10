-- levels.lua --

-- levels.lua is used to load and generate levels by adding zones w/ enemies to a flat block which
-- will be the type "ground" at some point in the future.

level = {
  bounds = { -- camera boundaries
    width = 0,
    height = windowHeight, -- at minimum should be equal to windowHeight
    left = 0,
    top = 0
  }
}

levels = {}
