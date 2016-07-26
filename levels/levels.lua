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

  -- player skins, location, and tilemap
  playerSkinV = nil, -- vertical
  playerSkinH = nil, -- horizontal
  tilemap = nil,
  startPos = nil,

  -- level functions
  levelLoad = nil, -- level Load func
  levelUpdate = nil, -- level Update func
  levelDraw = nil -- level Draw func
}

function loadLevel(levelName, world, levelFunctions)
  getLevel(levelName, level)

  for i = 1, #level.zones do
    addZone(level.zones[i].name, level.zones[i].x, level.zones[i].y, level.zones[i].w, level.zones[i].h, level.zones[i].enemies)
  end

  --level.levelUpdate()
  levelFunctions.load, levelFunctions.update, levelFunctions.draw = level.levelLoad, level.levelUpdate, level.levelDraw

  return level.playerSkinV, level.playerSkinH, level.tilemap, level.startPos
end
