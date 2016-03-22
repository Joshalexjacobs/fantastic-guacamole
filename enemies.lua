-- enemies.lua --
require 'enemies/behaviours'

-- Enemy Object --
local enemy = {
  name = "enemy",
  health = 0,
  x = 500,
  y = 50, -- 511
  w = 36, -- 32
  h = 72, -- 64
  speed = 200, -- increase me! 100
  gravity = 9.8,
  dx = 0,
  dy = 0,
  direction = "",
  isDead = false,
  behaviours = {},
  filter = function(item, other) -- default enemy filter
    if other.name == "player" then
      return 'slide'
    elseif other.name == "block" then
      return 'slide'
    end
  end,
  color = {255, 0, 0, 255}
}

-- Enemy Functions --
function enemy.new()
  local self = enemy
  return self
end

function enemy.update(dt, newEnemy)
  for i=1, table.getn(newEnemy.behaviours) do
    newEnemy.behaviours[i].update(dt, newEnemy)
  end
end

function enemy.updateWorld(dt, newEnemy, world)
  -- constant force of gravity --
  newEnemy.dy = newEnemy.dy + (newEnemy.gravity * dt)

  newEnemy.x, newEnemy.y = world:move(newEnemy, newEnemy.x + newEnemy.dx, newEnemy.y + newEnemy.dy, newEnemy.filter)
end

-- Create Globals Table --
enemies = {}

-- General Functions --
local function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function addEnemy(ID, x, y, dir, world)
  local newEnemy = copy(enemy, newEnemy) -- create a copy of enemy
  newEnemy.x, newEnemy.y, newEnemy.direction = x, y, dir
  newEnemy.behaviours = parseID(ID) -- parse and return behaviours for this enemy

  world:add(newEnemy, newEnemy.x, newEnemy.y, newEnemy.w, newEnemy.h) -- add enemy to world collision
  table.insert(enemies, newEnemy)
end

function updateEnemies(dt, world) -- include world here?
  for i, newEnemy in ipairs(enemies) do -- loops through number of enemies
    newEnemy.update(dt, newEnemy)
    newEnemy.updateWorld(dt, newEnemy, world)

    if newEnemy.isDead then
      world:remove(newEnemy) -- remove from world...
      table.remove(enemies, i) -- ...and the bullets table
    end
  end
end

function drawEnemies()
  for _, newEnemy in ipairs(enemies) do
    setColor(newEnemy.color) -- set each bullet's color
    love.graphics.rectangle("fill", newEnemy.x, newEnemy.y, newEnemy.w, newEnemy.h)
  end
end
