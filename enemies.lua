-- enemies.lua --

require 'enemies/behaviours'

-- Enemy Object --
local enemy = {
  health = 0,
  x = 500,
  y = 50, -- 511
  w = 32,
  h = 64,
  speed = 100, -- increase me!
  gravity = 9.8,
  dx = 0,
  dy = 0,
  direction = "",
  behaviours = {},
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

  enemy.x, enemy.y = world:move(enemy, enemy.x + enemy.dx, enemy.y + enemy.dy)
end

enemies = {}

-- function generateEnemies() -- randomly generates an enemy based on optional parameters

function addEnemy(ID, world)
  enemy.behaviours = parseID(ID)
  world:add(enemy, enemy.x, enemy.y, enemy.w, enemy.h)
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
