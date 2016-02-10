-- enemies.lua --

require 'enemies/behaviours'

-- Enemy Object --
local enemy = {
  name = "enemy",
  health = 0,
  x = 500,
  y = 50, -- 511
  w = 32,
  h = 64,
  speed = 10, -- increase me! 100
  gravity = 9.8,
  dx = 0,
  dy = 0,
  direction = "",
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
function enemy.update(dt)
  for i=1, table.getn(enemy.behaviours) do
    enemy.behaviours[i].update(dt, enemy)
  end
end

function enemy.updateWorld(dt, world)
  -- constant force of gravity --
  enemy.dy = enemy.dy + (enemy.gravity * dt)

  enemy.x, enemy.y = world:move(enemy, enemy.x + enemy.dx, enemy.y + enemy.dy, enemy.filter)
end

enemies = {}

-- function generateEnemies() -- randomly generates an enemy based on optional parameters

function addEnemy(ID, world)
  enemy.behaviours = parseID(ID) -- returns list of behaviour functions
  world:add(enemy, enemy.x, enemy.y, enemy.w, enemy.h) -- add enemy to world collision
  table.insert(enemies, enemy)
end

function updateEnemies(dt, world) -- include world here?
  for _,newEnemy in ipairs(enemies) do -- loops through number of enemies
    newEnemy.update(dt)

    newEnemy.updateWorld(dt, world)
  end
end

function drawEnemies()
  for _, enemy in ipairs(enemies) do
    setColor(enemy.color) -- set each bullet's color
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
  end
end

return enemies
