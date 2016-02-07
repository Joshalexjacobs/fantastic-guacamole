-- bullets.lua --

local bullets = {}

function addBullet(xPos, yPos, direction, bulColor) -- add world as parameter
  newBullet = {x = xPos, y = yPos, w = 5, h = 5, speed = 500, dir = direction,  -- x pos, y pos, w, h, speed...
    color = bulColor or {255, 255, 255, 255}} -- ...color
  -- add to world...
  table.insert(bullets, newBullet)
end

function updateBullets(dt, left) -- add world as a parameter
  -- add if statement for if bullet is colliding with an object...
  for i, bullet in ipairs(bullets) do
    if(bullet.x > left + windowWidth + bullet.w) or (bullet.x < left - bullet.w) then -- if a bullet leaves the play area...
      table.remove(bullets, i) -- ...remove it from the bullets table
    end

    if bullet.dir == 1 then
      bullet.x = bullet.x + (bullet.speed * dt) -- use world update
    elseif bullet.dir == 0 then
      bullet.x = bullet.x - (bullet.speed * dt) -- use world update
    end
  end
end

function drawBullets()
  for i, bullet in ipairs(bullets) do
    setColor(bullet.color) -- set each bullet's color
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.w, bullet.h)
  end
end
