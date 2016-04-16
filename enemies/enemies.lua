-- enemies.lua --

local function defaultBehaviour(dt, entity)
  -- does nothing
end

-- Enemy Object --
local enemy = {
  type = "enemy", -- type
  name = nil,
  health = nil,
  spriteSheet = nil,
  spriteGrid = nil,
  animations = nil,
  curAnim = 1,
  x = 500,
  y = 50, -- 511
  w = 36, -- 32
  h = 72, -- 64
  speed = 200,
  gravity = 9.8,
  dx = 0,
  dy = 0,
  maxVelocity = 7.0,
  direction = nil,
  prevDir = nil,
  isDead = false,
  behaviour = defaultBehaviour,
  filter = function(item, other) -- default enemy filter
    if other.type == "player" then
      return 'cross'
    elseif other.type == "block" or other.type == "ground" then
      return 'slide'
    end
  end,
  color = {255, 0, 0, 255}
}

-- Enemy Functions --
--function enemy.new()
  --local self = enemy
  --return self
--end

function enemy.update(dt, newEnemy)
  newEnemy.behaviour(dt, newEnemy)
end

function enemy.updateWorld(dt, newEnemy, world)
  -- this block locks in our velocity to maxVelocity
  local v = math.sqrt(newEnemy.dx^2 + newEnemy.dy^2)
  if v > newEnemy.maxVelocity then
    local vs = newEnemy.maxVelocity/v
    newEnemy.dx = newEnemy.dx*vs
    newEnemy.dy = newEnemy.dy*vs
  end

  -- constant force of gravity --
  newEnemy.dy = newEnemy.dy + (newEnemy.gravity * dt)

  newEnemy.x, newEnemy.y, cols, len = world:move(newEnemy, newEnemy.x + newEnemy.dx, newEnemy.y + newEnemy.dy, newEnemy.filter)

  for i = 1, len do
    if cols[i].other.type == "player" then
      cols[i].other.killPlayer(world)
    end
  end
end

function enemy.draw(newEnemy)
  newEnemy.animations[newEnemy.curAnim]:draw(newEnemy.spriteSheet, newEnemy.x, newEnemy.y, 0, 2.5, 2.5, 11, 18.5) -- SCALED UP 2.5, 11 and 18.5 are offsets
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

function addEnemy(name, x, y, dir, world)
  local newEnemy = copy(enemy, newEnemy) -- create a copy of enemy
  newEnemy.name, newEnemy.x, newEnemy.y, newEnemy.direction = name, x, y, dir

  getEnemy(newEnemy) -- update newEnemy depending on it's name

  -- flip it's starting animation, any other flips must be done in enemy update function
  if newEnemy.direction == "left" then newEnemy.animations[newEnemy.curAnim]:flipH() end

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
    -- love.graphics.rectangle("line", newEnemy.x, newEnemy.y, newEnemy.w, newEnemy.h)
    newEnemy.draw(newEnemy)
  end
end
