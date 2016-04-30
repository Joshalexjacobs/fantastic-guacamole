-- bullets.lua --

local bullets = {}

local bulletFilter = function(item, other)
  if other.type == "enemy" then
    return 'cross'
  end
end

function addBullet(xPos, yPos, direction, world, newDir, bulColor) -- add world as parameter
  newBullet = {type = "bullet", x = xPos, y = yPos, w = 5, h = 5, speed = 500, dir = direction, actualDir = newDir, -- x pos, y pos, w, h, speed...
    color = bulColor or {255, 255, 255, 255}, dx = 0, dy = 0, isDead = false} -- ...color, dx and dy

  world:add(newBullet, newBullet.x, newBullet.y, newBullet.w, newBullet.h) -- add all bullets to world...
  table.insert(bullets, newBullet)
end

function updateBullets(dt, left, world) -- add world as a parameter
  for i, bullet in ipairs(bullets) do
    --local cols, len -- cols is an array of objects the bullet is coliding with and len is the length of cols

    bullet.dx = math.cos(bullet.actualDir) * bullet.speed * dt
    bullet.dy = math.sin(bullet.actualDir) * bullet.speed * dt
    bullet.x, bullet.y, cols, len = world:move(bullet, bullet.x - bullet.dx, bullet.y + bullet.dy, bulletFilter) -- update world

    for j = 1, len do
      if cols[j].other.type == "enemy" then
        bullet.isDead = true
        cols[j].other.isDead = true
        break
      elseif cols[j].other.type == "block" or cols[j].other.type == "ground" then -- !!! when a bullet collides with the ground it isn't being destroyed... definitely a bug !!!
        bullet.isDead = true
        break
      end
    end

    if(bullet.x > left + windowWidth + bullet.w) or (bullet.x < left - bullet.w) or bullet.isDead == true then -- if a bullet leaves the play area...
      world:remove(bullet) -- remove from world...
      table.remove(bullets, i) -- ...and the bullets table
    end -- always perform this check last
  end
end

function drawBullets()
  for i, bullet in ipairs(bullets) do
    setColor(bullet.color) -- set each bullet's color
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.w, bullet.h)
  end
end
