-- animation.lua --

animations = {
  {
    name = "runner",
    x = nil,
    y = nil,
    w = nil,
    h = nil
  }
}

local function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function getAnimation(name, image)
  --[[
  local retImg = love.graphics.newImage('img/player/player.png')
  local retGrid = anim8.newGrid(34, 48, 102, 480, 0, 0, 0) --432

  retAnimations = {
    anim8.newAnimation(player.spriteGrid('2-3', 7), 0.6), -- 1 idle
    anim8.newAnimation(player.spriteGrid('1-3', '1-2'), 0.1), -- 2 idleRun
    anim8.newAnimation(player.spriteGrid('1-3', '3-4'), 0.1), -- 3 horizontalShotRun
    anim8.newAnimation(player.spriteGrid('1-3', '5-6'), 0.1), -- 4 diagShotRun
    anim8.newAnimation(player.spriteGrid(1, 7), 0.1), -- 5 lookUp
    anim8.newAnimation(player.spriteGrid('1-3', 8, 1, 9), 0.1), -- 6 jump/fall
    anim8.newAnimation(player.spriteGrid('2-3', 9, 1, 10), 0.1 ) -- 7 diagShotRunDown
  }
  ]]

  -- return retImg, retGrid, retAnimations
end
