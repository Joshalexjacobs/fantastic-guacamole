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
  shootPoint = {x = 0, y = 0}, -- point that determines where bullets spawn (in relation to enemy.x and enemy.y)
  scale = {x = nil, y = nil, offX = nil, offY = nil},
  worldOffSet = {offX = 0, offY = 0},
  x = 0,
  y = 0,
  w = 0,
  h = 0,
  speed = 100, -- 110
  gravity = 9.8,
  dx = 0,
  dy = 0,
  maxVelocity = 7.0,
  direction = nil,
  prevDir = nil,
  isFalling = false,
  isDead = false,
  playDead = false,
  timers = {},
  behaviour = defaultBehaviour,
  specialDraw = nil,
  uniqueParam = nil,
  uniqueStorage = nil,
  filter = function(item, other) -- default enemy filter
    if other.type == "player" then
      return 'cross'
    elseif other.type == "block" or other.type == "ground" or other.type == "enemyPlatform" then
      return 'slide'
    end
  end,
  collision = function(cols, len, entity, world)
    for i = 1, len do
      if cols[i].other.type == "player" and entity.isDead == false then
        cols[i].other.killPlayer(world)
        print(entity.name)
      end
    end
  end,
  color = {255, 0, 0, 255}
}

-- Enemy Functions --
function enemy.update(dt, newEnemy, world)
  newEnemy.behaviour(dt, newEnemy, world)

  -- this block locks in our velocity to maxVelocity
  local v = math.sqrt(newEnemy.dx^2 + newEnemy.dy^2)
  if v > newEnemy.maxVelocity then
    local vs = newEnemy.maxVelocity/v
    newEnemy.dx = newEnemy.dx*vs
    newEnemy.dy = newEnemy.dy*vs
  end

  -- constant force of gravity --
  newEnemy.dy = newEnemy.dy + (newEnemy.gravity * dt)

  if newEnemy.playDead == false then
    newEnemy.x, newEnemy.y, cols, len = world:move(newEnemy, newEnemy.x + newEnemy.dx, newEnemy.y + newEnemy.dy, newEnemy.filter)
  end

  newEnemy.collision(cols, len, newEnemy, world)

end

function enemy.draw(newEnemy)
  if newEnemy.spriteSheet == nil then return false end

  newEnemy.animations[newEnemy.curAnim]:draw(newEnemy.spriteSheet, newEnemy.x, newEnemy.y, 0, newEnemy.scale.x, newEnemy.scale.y, newEnemy.scale.offX, newEnemy.scale.offY)
  if newEnemy.specialDraw ~= nil then newEnemy.specialDraw(newEnemy) end
end

-- Create Globals Table --
enemies = {}

-- General Functions --
function addEnemy(name, x, y, dir, world, uniqueParam)
  local newEnemy = copy(enemy, newEnemy) -- create a copy of enemy
  newEnemy.name, newEnemy.x, newEnemy.y, newEnemy.direction = name, x, y, dir

  if uniqueParam ~= nil then newEnemy.uniqueParam = uniqueParam end

  getEnemy(newEnemy) -- update newEnemy depending on it's name

  newEnemy.x = newEnemy.x + newEnemy.worldOffSet.offX
  newEnemy.y = newEnemy.y + newEnemy.worldOffSet.offY

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
    newEnemy.update(dt, newEnemy, world)

    if newEnemy.hp <= 0 then
      newEnemy.isDead = true
    end

    if newEnemy.playDead and world:hasItem(newEnemy) then
      world:remove(newEnemy) -- remove from world...
      table.remove(enemies, i)
    end
  end
end

function drawEnemies()
  for _, newEnemy in ipairs(enemies) do
    --setColor(newEnemy.color) -- set each bullet's color
    newEnemy.draw(newEnemy)
    --love.graphics.rectangle("line", newEnemy.x, newEnemy.y, newEnemy.w, newEnemy.h)
  end
end
