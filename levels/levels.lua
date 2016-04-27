-- levels.lua --

level = {
  name = "nil",
  bounds = { -- camera boundaries
    width = 0,
    height = 0, -- at minimum should be equal to windowHeight
    left = 0,
    top = 0
  },
  ground = {},
  walls = {},
  zones = {}
}

function loadLevel(levelName, world)
  getLevel(levelName, level)

  for i = 1, #level.ground do
    addBlock(level.ground[i].x, level.ground[i].y, level.ground[i].w, level.ground[i].h, world, "ground")
  end

  for i = 1, #level.walls do
    addBlock(level.walls[i].x, level.walls[i].y, level.walls[i].w, level.walls[i].h, world, "block")
  end

  for i = 1, #level.zones do
    addZone(level.zones[i].x, level.zones[i].y, level.zones[i].w, level.zones[i].h, level.zones[i].enemies)
  end
end
