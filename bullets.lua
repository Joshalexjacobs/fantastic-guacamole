-- bullets.lua --

local bullets = {}

function addBullet(xPos, yPos, direction, bulColor)
  newBullet = {x = xPos, y = yPos, w = 5, h = 5, speed = 500, dir = direction,  -- x pos, y pos, w, h, speed...
    color = bulColor or {255, 255, 255, 255}} -- ...color
  table.insert(bullets, newBullet)
end

function updateBullets(dt, left)
  for i, bullet in ipairs(bullets) do
    if(bullet.x > left + windowWidth + bullet.w) or (bullet.x < left - bullet.w) then -- if a bullet leaves the play area...
      table.remove(bullets, i) -- ...remove it from the bullets table
    end

    if bullet.dir == 1 then
      bullet.x = bullet.x + (bullet.speed * dt)
    elseif bullet.dir == 0 then
      bullet.x = bullet.x - (bullet.speed * dt)
    end
  end
end

function drawBullets()
  for i, bullet in ipairs(bullets) do
    setColor(bullet.color) -- set each bullet's color
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.w, bullet.h)
  end
end
