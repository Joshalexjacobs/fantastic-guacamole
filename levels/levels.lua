-- levels.lua --

level = {
  name = "nil",
  bounds = { -- camera boundaries
    levelWidth = 0,
    levelHeight = 0,
    left = 0,
    top = 0
  },
  zones = {},
  playerSkinV = nil, -- vertical
  playerSkinH = nil, -- horizontal
  tilemap = nil,
  startPos = nil
}

function loadLevel(levelName, world)
  getLevel(levelName, level)

  for i = 1, #level.zones do
    addZone(level.zones[i].name, level.zones[i].x, level.zones[i].y, level.zones[i].w, level.zones[i].h, level.zones[i].enemies)
  end

  return level.playerSkinV, level.playerSkinH, level.tilemap, level.startPos
end
