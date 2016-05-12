-- bullets.lua --

local bullet = {
  type = "bullet",
  x = nil,
  y = nil,
  w = 5,
  h = 5,
  dx = 0,
  dy = 0,
  speed = 400,
  dir = nil,
  actualDir = nil,
  isDead = false,
  color = {255, 255, 255, 255},
  filter = nil,
  reaction = nil,
  curAnim = 1,
  spriteSheet = nil,
  spriteGrid = nil,
  aniamtions = {},
  timers = {}
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

  if other.type == "block" or other.type == "ground" then
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

  if other.type == "block" or other.type == "ground" then
    return 'cross'
  end
end

-- reaction functions --
local playerBullet = function(entity, cols, len)
  for j = 1, len do
    if cols[j].other.type == "enemy" then
      entity.isDead = true -- destroy bullet
      cols[j].other.hp = cols[j].other.hp - 1 -- decrement other.hp
    end

    if cols[j].other.type == "block" or cols[j].other.type == "ground" then
      entity.isDead = true
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

  -- animations --
  newBullet.spriteSheet = love.graphics.newImage("img/other/playerBullet.png")
  newBullet.spriteGrid = anim8.newGrid(16, 16, 48, 32, 0, 0, 0)
  newBullet.animations = {
    anim8.newAnimation(newBullet.spriteGrid('1-2', 1), 0.04, 'pauseAtEnd'), -- shot
    anim8.newAnimation(newBullet.spriteGrid(3, 1, 1, 1), 0.05) -- dead
  }

  world:add(newBullet, newBullet.x, newBullet.y, newBullet.w, newBullet.h) -- add all bullets to world...
  table.insert(bullets, newBullet)
end

function updateBullets(dt, left, world) -- add world as a parameter
  for i, newBullet in ipairs(bullets) do
    --local cols, len -- cols is an array of objects the newBullet is coliding with and len is the length of cols

    newBullet.dx = math.cos(newBullet.actualDir) * newBullet.speed * dt
    newBullet.dy = math.sin(newBullet.actualDir) * newBullet.speed * dt
    if newBullet.isDead == false then
      newBullet.x, newBullet.y, cols, len = world:move(newBullet, newBullet.x - newBullet.dx, newBullet.y + newBullet.dy, newBullet.filter) -- update world
    end

    newBullet.reaction(newBullet, cols, len)

    if(newBullet.x > left + windowWidth + newBullet.w) or (newBullet.x < left - newBullet.w) then
      world:remove(newBullet) -- remove from world...
      table.remove(bullets, i) -- ...and the bullets table
    end

    if newBullet.isDead == true then -- if a newBullet leaves the play area...
      if checkTimer("dead", newBullet.timers) == false then
        if world:hasItem(newBullet) then
          world:remove(newBullet) -- remove from world...
        end
        newBullet.curAnim = 2
        addTimer(0.1, "dead", newBullet.timers)
      end

      if updateTimer(dt, "dead", newBullet.timers) then
        table.remove(bullets, i) -- ...and the bullets table
      end
    end -- always perform this check last

    newBullet.animations[bullet.curAnim]:update(dt)
  end
end

function drawBullets()
  for i, newBullet in ipairs(bullets) do
    setColor(newBullet.color) -- set each newBullet's color
    --love.graphics.rectangle("fill", newBullet.x, newBullet.y, newBullet.w, newBullet.h)
    newBullet.animations[newBullet.curAnim]:draw(newBullet.spriteSheet, newBullet.x, newBullet.y, 0, 0.8, 0.8, 5, 5)
  end
end
