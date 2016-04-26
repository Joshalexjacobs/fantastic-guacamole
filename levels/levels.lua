-- levels.lua --

level = {
  name = "nil",
  bounds = { -- camera boundaries
    width = 0,
    height = 0, -- at minimum should be equal to windowHeight
    left = 0,
    top = 0
  },
  ground = { -- will eventually be an array of ground types
    x = 0,
    y = 0,
    w = 0,
    h = 0
  },
  zones = {}
}

function loadLevel(levelName, world)
  getLevel(levelName, level)

  for i = 1, #level.ground do
    addBlock(level.ground[i].x, level.ground[i].y, level.ground[i].w, level.ground[i].h, world, "ground") -- floor/ love.graphics.getHeight() - 150
  end

  for i = 1, #level.zones do
    addZone(level.zones[i].x, level.zones[i].y, level.zones[i].w, level.zones[i].h, level.zones[i].enemies)
  end
end