-- enemies.lua --

local function defaultBehaviour(dt, entity)
  -- does nothing
end

-- Enemy Object --
local enemy = {
  type = "enemy", -- type
  name = nil,
  hp = nil,
  spriteSheet = nil,
  spriteGrid = nil,
  animations = nil,
  curAnim = 1,
  scale = {x = nil, y = nil, offX = nil, offY = nil},
  x = 0,
  y = 0,
  w = 0,
  h = 0,
  speed = 180,
  gravity = 9.8,
  dx = 0,
  dy = 0,
  maxVelocity = 7.0,
  direction = nil,
  prevDir = nil,
  isFalling = false,
  isDead = false,
  playDead = nil,
  timers = {},
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

  if not newEnemy.isDead then
    newEnemy.x, newEnemy.y, cols, len = world:move(newEnemy, newEnemy.x + newEnemy.dx, newEnemy.y + newEnemy.dy, newEnemy.filter)
  end

  for i = 1, len do
    if cols[i].other.type == "player" then
      cols[i].other.killPlayer(world)
    end
  end
end

function enemy.draw(newEnemy)
  newEnemy.animations[newEnemy.curAnim]:draw(newEnemy.spriteSheet, newEnemy.x, newEnemy.y, 0, newEnemy.scale.x, newEnemy.scale.y, newEnemy.scale.offX, newEnemy.scale.offY)
end

-- Create Globals Table --
enemies = {}

-- General Functions --
function addEnemy(name, x, y, dir, world)
  local newEnemy = copy(enemy, newEnemy) -- create a copy of enemy
  newEnemy.name, newEnemy.x, newEnemy.y, newEnemy.direction = name, x, y, dir

  getEnemy(newEnemy) -- update newEnemy depending on it's name

  -- flip all starting animations, any other flips must be done in enemy behaviour function
  if newEnemy.direction == "left" then
    for i = 1, #newEnemy.animations do
      newEnemy.animations[i]:flipH()
    end
  end

  world:add(newEnemy, newEnemy.x, newEnemy.y, newEnemy.w, newEnemy.h) -- add enemy to world collision
  table.insert(enemies, newEnemy)
end

function removeEnemyFromWorld(newEnemy, world)
  world:remove(newEnemy)
end

function updateEnemies(dt, world) -- include world here?
  for i, newEnemy in ipairs(enemies) do -- loops through number of enemies
    newEnemy.update(dt, newEnemy)
    newEnemy.updateWorld(dt, newEnemy, world)

    if newEnemy.hp <= 0 then
      newEnemy.isDead = true
      --newEnemy.playDead = true
    end

    --if newEnemy.isDead and newEnemy.playDead == false then
    if newEnemy.isDead and world:hasItem(newEnemy) then
      world:remove(newEnemy) -- remove from world...
      --table.remove(enemies, i) -- ...and the bullets table
    end

    if newEnemy.playDead then
      table.remove(enemies, i)
    end
  end
end

function drawEnemies()
  for _, newEnemy in ipairs(enemies) do
    --setColor(newEnemy.color) -- set each bullet's color
    newEnemy.draw(newEnemy)
    --love.graphics.rectangle("line", newEnemy.x, newEnemy.y, newEnemy.w, newEnemy.h)
    --love.graphics.rectangle("line", newEnemy.x, newEnemy.y, 50, 50) --range?
  end
end
