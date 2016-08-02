-- bullets.lua --

--local hit = love.audio.newSource("sound/bullet sound/hit.wav", static)
--hit:setVolume(0.1)
--love.audio.play(hit)

local pbullet = {
  type = "invincible",
  owner = "player",
  hitSound = nil,
  hit = false,
  x = nil,
  y = nil,
  w = 4, -- 8
  h = 4, -- 8
  dx = 0,
  dy = 0,
  speed = 400,
  dir = nil,
  actualDir = nil,
  isShot = false,
  isDead = false,
  color = {255, 255, 255, 255},
  filter = function(item, other)
    if other.type == "enemy" or other.type == "boss" or other.type == "bubble" then
      return 'touch' -- used to be cross
    elseif other.type == "block" or other.type == "ground" then
      return 'touch' -- used to be cross
    end
  end,
  reaction = function(entity, cols, len)
    for j = 1, len do
      if cols[j].other.type == "enemy" or cols[j].other.type == "boss" or cols[j].other.type == "bubble" then
        entity.hit = true
        entity.isDead = true -- destroy bullet
        cols[j].other.hp = cols[j].other.hp - 1 -- decrement other.hp
      elseif cols[j].other.type == "block" or cols[j].other.type == "ground" then
        entity.hit = true
        entity.isDead = true
      end
    end
  end,
  curAnim = 1,
  spriteSheet = nil,
  spriteGrid = nil,
  animations = {},
  timers = {}
}

pProneFilter = function(item, other)
  if other.type == "enemy" or other.type == "boss" then
    return 'touch'
  elseif other.type == "block" then
    return 'touch'
  end
end

local ebullet = {
  type = "invincible",
  owner = "enemy",
  x = nil,
  y = nil,
  w = 8,
  h = 8,
  dx = 0,
  dy = 0,
  speed = 150,
  dir = nil,
  actualDir = nil,
  isShot = false,
  isDead = false,
  color = {255, 255, 255, 255},
  filter = function(item, other)
    if other.type == "player" then
      return 'touch' -- used to be cross
    elseif other.type == "block" or other.type == "ground" then
      return 'touch' -- used to be cross
    end
  end,
  reaction = function(entity, cols, len)
    for j = 1, len do
      if cols[j].other.type == "player" then
        entity.isDead = true -- destroy bullet
        cols[j].other.killPlayer(world)
        break
      elseif cols[j].other.type == "block" or cols[j].other.type == "ground" then
        entity.isDead = true
        break
      end
    end
  end,
  curAnim = 1,
  spriteSheet = nil,
  spriteGrid = nil,
  animations = {},
  timers = {}
}

local pBulletsCount = 0 -- max is 4

local eBullets = {} -- enemy bullets
local pBullets = {} -- player bullets

function loadBullet()
  -- load player bullets
  pbullet.spriteSheet = love.graphics.newImage("img/other/newBullet.png")

  pbullet.spriteGrid = anim8.newGrid(16, 8, 48, 32, 0, 0, 0)
  pbullet.animations = {
    anim8.newAnimation(pbullet.spriteGrid('1-2', 1), 0.005, 'pauseAtEnd'), -- 1 muzzle flash
    anim8.newAnimation(pbullet.spriteGrid(3, 1, '1-3', 2), 0.08), -- 2 shot
    anim8.newAnimation(pbullet.spriteGrid('1-3', '3-4'), 0.02, 'pauseAtEnd'), -- 3 dead
  }

  pbullet.hitSound = love.audio.newSource("sound/bullet sound/hit.wav", static)
  pbullet.hitSound:setVolume(0.00)

  -- load enemy bullets
  ebullet.spriteSheet = love.graphics.newImage("img/other/enemy bullet.png")

  ebullet.spriteGrid = anim8.newGrid(16, 8, 48, 32, 0, 0, 0)
  ebullet.animations = {
    anim8.newAnimation(ebullet.spriteGrid('1-2', 1), 0.005, 'pauseAtEnd'), -- 1 muzzle flash
    anim8.newAnimation(ebullet.spriteGrid(3, 1, 1, 2), 0.25), -- 2 shot
    anim8.newAnimation(ebullet.spriteGrid('1-3', '3-4'), 0.02, 'pauseAtEnd'), -- 3 dead
  }
end

function addBullet(danger, xPos, yPos, direction, world, newDir, isProne) -- add world as parameter

  isProne = isProne or false

  if pBulletsCount >= player.bulletsMax and danger == false then -- 4
    return false
  elseif danger == false then
    newBullet = copy(pbullet, newBullet)
    newBullet.x, newBullet.y, newBullet.dir, newBullet.actualDir = xPos, yPos, direction, newDir
    pBulletsCount = pBulletsCount + 1
    if isProne then newBullet.filter = pProneFilter end
  elseif danger == true then
    newBullet = copy(ebullet, newBullet)
    newBullet.x, newBullet.y, newBullet.dir, newBullet.actualDir = xPos, yPos, direction, newDir
  end

  addTimer(0.01, "flash", newBullet.timers)

  world:add(newBullet, newBullet.x, newBullet.y, newBullet.w, newBullet.h) -- add all bullets to world...
  if danger then table.insert(eBullets, newBullet) else table.insert(pBullets, newBullet) end
  return true
end

local function handleBullets(dt, left, viewportWidth, world, bullets)
  for i, newBullet in ipairs(bullets) do
    newBullet.animations[newBullet.curAnim]:update(dt) -- update animations

    if updateTimer(dt, "flash", newBullet.timers) and newBullet.isDead == false and newBullet.isShot == false then
      newBullet.curAnim = 2
      newBullet.isShot = true
      newBullet.type = "bullet"
    end

    newBullet.dx = math.cos(newBullet.actualDir) * newBullet.speed * dt
    newBullet.dy = math.sin(newBullet.actualDir) * newBullet.speed * dt
    if newBullet.isDead == false then
      newBullet.x, newBullet.y, cols, len = world:move(newBullet, newBullet.x + newBullet.dx, newBullet.y + newBullet.dy, newBullet.filter) -- update world
    end

    newBullet.reaction(newBullet, cols, len)

    if (newBullet.x > left + viewportWidth + newBullet.w) or (newBullet.x < left - newBullet.w) or (newBullet.y < -16) then
      newBullet.isDead = true
    end

    if newBullet.isDead == true then -- if a newBullet leaves the play area...
      if checkTimer("dead", newBullet.timers) == false then
        if world:hasItem(newBullet) then
          world:remove(newBullet) -- remove from world...
        end
        newBullet.curAnim = 3
        addTimer(0.1, "dead", newBullet.timers)
        if newBullet.hit == true then
          love.audio.play(newBullet.hitSound)
        end
      end

      if updateTimer(dt, "dead", newBullet.timers) then

        table.remove(bullets, i) -- ...and the bullets table
        if newBullet.owner == "player" then
          pBulletsCount = pBulletsCount - 1
        end
      end
    end
  end
end

function updateBullets(dt, left, viewportWidth, world) -- add world as a parameter
  handleBullets(dt, left, viewportWidth, world, pBullets)
  handleBullets(dt, left, viewportWidth, world, eBullets)
end

function drawBullets()
  for _, newBullet in ipairs(pBullets) do
    newBullet.animations[newBullet.curAnim]:draw(newBullet.spriteSheet, newBullet.x, newBullet.y, newBullet.actualDir, 1, 1, 10, newBullet.actualDir + 3)
    --love.graphics.rectangle("line", newBullet.x, newBullet.y, newBullet.w, newBullet.h)
  end

  for _, newBullet in ipairs(eBullets) do
    newBullet.animations[newBullet.curAnim]:draw(newBullet.spriteSheet, newBullet.x, newBullet.y, newBullet.actualDir, 1, 1, newBullet.actualDir + 14, newBullet.actualDir + 5)
    --love.graphics.rectangle("line", newBullet.x, newBullet.y, newBullet.w, newBullet.h)
  end
end
