-- enemies.lua --

require 'enemies/behaviours'

-- Enemy Object --
local enemy = {
  health = 0,
  x = 500,
  y = 511,
  w = 32,
  h = 64,
  speed = 100,
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

enemies = {}

-- function generateEnemies() -- randomly generates an enemy based on optional parameters

function addEnemy(ID)
  enemy.behaviours = parseID(ID)
  -- add enemy to the world
  table.insert(enemies, enemy)
end

function updateEnemies(dt)
  for _,newEnemy in ipairs(enemies) do -- loops through number of enemies
    newEnemy.update(dt)
  end
end

function drawEnemies()
  for _, enemy in ipairs(enemies) do
    setColor(enemy.color) -- set each bullet's color
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
  end
end

return enemies
