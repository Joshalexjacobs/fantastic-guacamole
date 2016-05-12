-- bullets.lua --

local bullet = {
  type = "bullet",
  x = nil,
  y = nil,
  w = 5,
  h = 5,
  dx = 0,
  dy = 0,
  speed = 300,
  dir = nil,
  actualDir = nil,
  isDead = false,
  color = {255, 255, 255, 255},
  filter = nil,
  reaction = nil
}

local bullets = {}

-- filter functions --
local playerFilter = function(item, other)
  if other.type == "enemy" then
    return 'cross'
  end

  if other.type == "player" then
    return 'cross'
  end
end

local enemyFilter = function(item, other)
  if other.type == "enemy" then
    return 'cross'
  end

  if other.type == "player" then
    return 'cross'
  end
end

-- reaction functions --
local playerBullet = function(entity, cols, len)
  for j = 1, len do
    if cols[j].other.type == "enemy" then
      entity.isDead = true -- destroy bullet
      cols[j].other.hp = cols[j].other.hp - 1 -- decrement other.hp
      break
    end
    if cols[j].other.type == "block" or cols[j].other.type == "ground" then -- !!! when a bullet collides with the ground it isn't being destroyed... definitely a bug !!!
      entity.isDead = true
      break
    end
  end
end

local enemyBullet = function(entity, cols, len)
  for j = 1, len do
    if cols[j].other.type == "player" then
      entity.isDead = true -- destroy bullet
      cols[j].other.killPlayer(world)
      break
    end
    if cols[j].other.type == "block" or cols[j].other.type == "ground" then -- !!! when a bullet collides with the ground it isn't being destroyed... definitely a bug !!!
      entity.isDead = true
      break
    end
  end
end

function addBullet(danger, xPos, yPos, direction, world, newDir, bulColor) -- add world as parameter
  newBullet = copy(bullet, newBullet)
  newBullet.x, newBullet.y, newBullet.dir, newBullet.actualDir = xPos, yPos, direction, newDir

  if danger == false then
    newBullet.filter = playerFilter
    newBullet.reaction = playerBullet
  elseif danger == true then
    newBullet.filter = enemyFilter
    newBullet.reaction = enemyBullet
  end

  world:add(newBullet, newBullet.x, newBullet.y, newBullet.w, newBullet.h) -- add all bullets to world...
  table.insert(bullets, newBullet)
end

function updateBullets(dt, left, world) -- add world as a parameter
  for i, newBullet in ipairs(bullets) do
    --local cols, len -- cols is an array of objects the newBullet is coliding with and len is the length of cols

    newBullet.dx = math.cos(newBullet.actualDir) * newBullet.speed * dt
    newBullet.dy = math.sin(newBullet.actualDir) * newBullet.speed * dt
    newBullet.x, newBullet.y, cols, len = world:move(newBullet, newBullet.x - newBullet.dx, newBullet.y + newBullet.dy, newBullet.filter) -- update world

    newBullet.reaction(newBullet, cols, len)

    if(newBullet.x > left + windowWidth + newBullet.w) or (newBullet.x < left - newBullet.w) or newBullet.isDead == true then -- if a newBullet leaves the play area...
      world:remove(newBullet) -- remove from world...
      table.remove(bullets, i) -- ...and the bullets table
    end -- always perform this check last
  end
end

function drawBullets()
  for i, newBullet in ipairs(bullets) do
    setColor(newBullet.color) -- set each newBullet's color
    love.graphics.rectangle("fill", newBullet.x, newBullet.y, newBullet.w, newBullet.h)

  end
end
