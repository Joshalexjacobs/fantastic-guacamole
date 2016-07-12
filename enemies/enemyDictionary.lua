-- enemyDictionary.lua --

-- general enemy functions --
local function getAngle(pX, pY, eX, eY) -- need to rewrite this bullshit function...
  angle = math.atan2(pY - eY, pX - eX)
  if angle > -0.40 and angle < 0.40 then -- right
    return math.pi
  elseif angle > 2.8 or angle < -2.8 then -- left
    return 0
  elseif angle < -1.57 and angle > -2.8 then -- up left
    return -0.523599
  elseif angle < -0.40 and angle > -1.57 then -- up right
    return (math.pi * 7)/6
  --[[elseif angle > 0.40 and angle < 1.57 then -- down right
    return (math.pi * 5)/6
  elseif angle > 1.57 and angle < 2.8 then -- down left
    return math.pi/6]]
  elseif angle > 0.40 and angle < 1.18 then -- down right
    return (math.pi * 5)/6
  elseif angle > 1.18 and angle < 1.8 then -- down
    return math.pi/2
  elseif angle > 1.8 and angle < 2.8 then -- down left
    return math.pi/6
  end
end

--------- BEHAVIOURS ---------

-- RUNNER --
local function runBehaviour(dt, entity, world)
    if entity.direction == "right" and entity.isDead == false then
      entity.dx = entity.speed * dt
    elseif entity.direction == "left" and entity.isDead == false then
      entity.dx = -(entity.speed * dt)
    end

    if entity.isDead and checkTimer("death", entity.timers) == false then
      addTimer(0.3, "death", entity.timers)
      entity.curAnim = 2
      entity.dy = -3.75
      entity.dx = 0
      entity.type = "dead"
    elseif entity.isDead and updateTimer(dt, "death", entity.timers) then
      entity.playDead = true
    end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

-- GRENADE --
local function grenadeBehaviour(dt, entity, world)
  if checkTimer("start", entity.timers) == false then
    entity.dy = -3.75
    entity.type = "invincible"
    addTimer(0.0, "start", entity.timers)
  end

  if entity.direction == "right" and entity.isDead == false then
    entity.dx = entity.speed * dt
  elseif entity.direction == "left" and entity.isDead == false then
    entity.dx = -(entity.speed * dt)
  end

  if entity.isDead and checkTimer("death", entity.timers) == false then
    addTimer(0.3, "death", entity.timers)
    entity.curAnim = 2
    entity.gravity = 0
    entity.dx, entity.dy = 0, 0
  elseif  entity.isDead and updateTimer(dt, "death", entity.timers) then
    entity.playDead = true
  end

  -- handle/update current animation running
  entity.animations[entity.curAnim]:update(dt)
end

-- PRONE SHOOTER --
local function proneShooterBehaviour(dt, entity, world)
  if player.x > entity.x - 160 and checkTimer("beginShooting", entity.timers) == false then
    addTimer(0.8, "beginShooting", entity.timers)
    --entity.type = "enemy" -- shooter cannot be hit until within range of the player
  elseif checkTimer("beginShooting", entity.timers) == true and updateTimer(dt, "beginShooting", entity.timers) == true and entity.isDead == false then
    addTimer(0.0, "shoot", entity.timers)
    addTimer(0.2, "resetShot", entity.timers)
  end

  if checkTimer("shoot", entity.timers) and updateTimer(dt, "shoot", entity.timers) and entity.isDead == false then
    entity.curAnim = 2
    local deviation = love.math.random(0.1, 1) * 0.02
    addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, "right", world, math.pi + deviation)
    resetTimer(2.2, "shoot", entity.timers)
    resetTimer(0.2, "resetShot", entity.timers)
  elseif entity.curAnim == 2 and updateTimer(dt, "resetShot", entity.timers) then
    entity.curAnim = 1
  end

  if entity.isDead and checkTimer("death", entity.timers) == false then
    addTimer(0.5, "death", entity.timers)
    entity.curAnim = 3
    entity.type = "dead"
  elseif entity.isDead and updateTimer(dt, "death", entity.timers) then
    entity.playDead = true
  end

  entity.animations[entity.curAnim]:update(dt)
end

-- LASER WALL --
local function laserWallBehaviour(dt, entity, world)
    if entity.isDead == false and world:hasItem(laserRect) == false then
      laserRect = {
        hp = 0, -- just so pBullet has something to subtract
        type = "enemy",
        filter = function(item, other) if other.type == "player" then return 'cross' end end,
        w = 2,
        h = 170,
        x = entity.x + entity.shootPoint.x,
        y = entity.y + entity.shootPoint.y
      }

      world:add(laserRect, laserRect.x, laserRect.y, laserRect.w, laserRect.h)
    end

    if world:hasItem(laserRect) then
      laserRect.x, laserRect.y, cols, len = world:move(laserRect, laserRect.x, laserRect.y, laserRect.filter)

      for i = 1, len do
        if cols[i].other.type == "player" and entity.isDead == false then
          cols[i].other.killPlayer(world)
        end
      end
    end

    if entity.isDead and checkTimer("death", entity.timers) == false then
      addTimer(0.3, "death", entity.timers)
      entity.curAnim = 2
      world:remove(laserRect) -- remove laser from world
    end

    --elseif entity.isDead and updateTimer(dt, "death", entity.timers) then
      --entity.playDead = true -- get rid of this so laserWall doesnt disappear after death ... or make a new bool called permanence
      -- .. if permanence set to true body stays after death animation and is only removed from the world
      -- .. if enemy is no longer visible in the playing field remove this player from the enemy list

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

-- LASER WALL SPECIAL DRAW --
local function laserWallDraw(entity, world) -- not sure if i'll need world or not?

  if entity.isDead then -- if laserWall is dead, draw burn mark and return false
    setColor({ 0, 0, 0, 50})
    love.graphics.rectangle("fill", entity.x + entity.shootPoint.x - 1, entity.y + 170 + 5, 4.5, 2)
    setColor({ 255, 255, 255, 255})
    return false
  end

  local drawing, index, groundLevel = true, 0, 155

  while drawing do
      --setColor({ 255, 0, 0, 50})
      --love.graphics.rectangle("fill", entity.x + entity.shootPoint.x - 1, entity.y + entity.shootPoint.y + index, 4.5, 10) -- transparent

      setColor({ love.math.random(200, 255), 0, 0, 255})
      love.graphics.rectangle("fill", entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y + index, 2.5, 10) -- laser segments

      if index >= groundLevel then drawing = false end -- stop drawing upon reaching the ground

      index = index + 10 -- increase the index after each segment
  end

  love.graphics.rectangle("fill", entity.x + entity.shootPoint.x - 1, entity.y + index + 5, 2.5, 2)
  love.graphics.rectangle("fill", entity.x + entity.shootPoint.x + 1, entity.y + index + 5, 2.5, 2)

  setColor({ 255, 255, 255, 255})
end

-- WIZARD --
local function wizardBehaviour(dt, entity, world)
    if checkTimer("followPlayer", entity.timers) == false and player.x > entity.x - 320 and player.x < entity.x + 320 then
      addTimer(0.0, "followPlayer", entity.timers)
      addTimer(0.0, "buffer", entity.timers)
      addTimer(2.0, "shoot", entity.timers)

      frames = {
        x = nil,
        y = nil,
        curFrame = 0 -- for wizard's shoot animation
      }
    elseif checkTimer("followPlayer", entity.timers) and entity.isDead == false then
      if player.x > entity.x + 50 and entity.isDead == false then
        entity.dx = 10 * dt

        if entity.direction == "left" then
          entity.direction = "right"
          for i = 1, #entity.animations do
            entity.animations[i]:flipH()
          end
        end

      elseif player.x < entity.x - 50 and entity.isDead == false then
        entity.dx = -(10 * dt)

        if entity.direction == "right" then
          entity.direction = "left"
          for i = 1, #entity.animations do
            entity.animations[i]:flipH()
          end
        end

      elseif entity.isDead == false then -- apply deceleration
        if entity.direction == "right" then -- moving right
          entity.dx = math.max((entity.dx - 0.2 * dt), 0)
        else -- moving left
          entity.dx = math.min((entity.dx + 0.2 * dt), 0)
        end
      end

      if updateTimer(dt, "shoot", entity.timers) and entity.curAnim ~= 2 then
        entity.curAnim = 2
        entity.animations[2]:gotoFrame(1)
        entity.animations[2]:resume()
      end

      if entity.curAnim == 2 and updateTimer(dt, "shoot", entity.timers) then
        local quad = entity.animations[entity.curAnim]:getFrameInfo()
        local x, y = quad:getViewport()

        if frames.x ~= x or frames.y ~= y then
          frames.x, frames.y = x, y
          frames.curFrame = frames.curFrame + 1
        end

        if updateTimer(dt, "buffer", entity.timers) and frames.curFrame == 9 then
          local deviation = love.math.random(40, 50) * 0.01
          local destination = math.atan2(player.y + 30 - entity.y + entity.shootPoint.y, player.x + 5 - entity.x + entity.shootPoint.y)

          if entity.direction == "right" then
            addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, "right", world, destination)
            addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, "right", world, destination + deviation)
            addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, "right", world, destination - deviation)
          else
            addBullet(true, entity.x - entity.shootPoint.x, entity.y - entity.shootPoint.y, "right", world, destination)
            addBullet(true, entity.x - entity.shootPoint.x, entity.y - entity.shootPoint.y, "right", world, destination + deviation)
            addBullet(true, entity.x - entity.shootPoint.x, entity.y - entity.shootPoint.y, "right", world, destination - deviation)
          end
          resetTimer(0.2, "buffer", entity.timers)
        elseif frames.curFrame == 13 then
          frames.x, frames.y, frames.curFrame = nil, nil, 0
          resetTimer(2.0, "shoot", entity.timers)
          entity.curAnim = 1
        end
      end

      entity.dy = 0.25 * math.sin(love.timer.getTime() * 4.1 * math.pi)
    end


    if entity.isDead and checkTimer("death", entity.timers) == false then
      addTimer(1.0, "death", entity.timers)
      entity.curAnim = 3
      entity.dy = -2
      entity.dx = 0
      entity.gravity = 9.8
      entity.type = "dead"
    elseif entity.isDead and updateTimer(dt, "death 2", entity.timers) then
      entity.playDead = true
    end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

--[[
******************************************************
******************************************************
******************************************************
********* UNUSED BEHAVIOUR FUNCTIONS BELOW ***********
******************************************************
******************************************************
******************************************************
]]

-- TARGET --
local function targetBehaviour(dt, entity, world)
  -- static

  if entity.isDead then
    -- create a timer.. etc
    entity.curAnim = 2
    addTimer(0.3, "death", entity.timers)
    if updateTimer(dt, "death", entity.timers) then
      entity.playDead = true
    end
  end

  entity.animations[entity.curAnim]:update(dt)
end

-- SHOOTER-RUNNER --
local function srBehaviour(dt, entity, world)
    -- set direction
    if player.x > entity.x and entity.direction ~= "right" then
      entity.direction = "right"

      for i = 1, #entity.animations do
        entity.animations[i]:flipH()
      end

    elseif player.x < entity.x and entity.direction ~= "left" then
      entity.direction = "left"

      for i = 1, #entity.animations do
        entity.animations[i]:flipH()
      end

    end

    -- movement/shooting
    -- run towards player until within 200 pixels and create timer
    if math.abs(entity.x - player.x) > 300 and not checkTimer("shoot", entity.timers) then
      entity.curAnim = 1
      if entity.direction == "right" then
        entity.dx = entity.speed * dt
      elseif entity.direction == "left" then
        entity.dx = -(entity.speed * dt)
      end
    else -- once timer is created, stop and shoot at the player
      entity.dx = 0

      addTimer(0.0, "shoot", entity.timers)

      if updateTimer(dt, "shoot", entity.timers) then
        angle = getAngle(player.x, player.y, entity.x, entity.y)

        if angle == math.pi or angle == 0 then
          entity.curAnim = 2 -- left/right
          if entity.direction == "right" then
            entity.shootPoint.x, entity.shootPoint.y = 45, 14 -- right
          elseif entity.direction == "left" then
            entity.shootPoint.x, entity.shootPoint.y = -15, 12 -- left
          end
        elseif angle == (math.pi * 7)/6 or angle == -0.523599 then
          entity.curAnim = 3 -- up
          if entity.direction == "right" then
            entity.shootPoint.x, entity.shootPoint.y = 32, -20
          elseif entity.direction == "left" then
            entity.shootPoint.x, entity.shootPoint.y = -2, -20
          end
        elseif angle == (math.pi * 5)/6 or angle == math.pi/6 then
          entity.curAnim = 4 -- down
          if entity.direction == "right" then
            entity.shootPoint.x, entity.shootPoint.y = 35, 25
          elseif entity.direction == "left" then
            entity.shootPoint.x, entity.shootPoint.y = -10, 25
          end
        end

        addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, entity.direction, world, angle)
        resetTimer(1.2, "shoot", entity.timers) -- add timer
      end
    end

    if entity.isDead then entity.playDead = true end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

-- STATIC-SHOOTER --
local function sBehaviour(dt, entity, world)
    -- set direction
    if player.x > entity.x and entity.direction ~= "right" then
      entity.direction = "right"

      for i = 1, #entity.animations do
        entity.animations[i]:flipH()
      end

    elseif player.x < entity.x and entity.direction ~= "left" then
      entity.direction = "left"

      for i = 1, #entity.animations do
        entity.animations[i]:flipH()
      end
    end

    if checkTimer("shoot", entity.timers) == false then
      addTimer(0.0, "shoot", entity.timers)
      addTimer(0.0, "secondShot", entity.timers)
    end

    if updateTimer(dt, "shoot", entity.timers) then
      angle = getAngle(player.x, player.y, entity.x, entity.y)

      if angle == math.pi or angle == 0 then
        entity.curAnim = 2 -- left/right
        if entity.direction == "right" then
          entity.shootPoint.x, entity.shootPoint.y = 45, 14 -- right
        elseif entity.direction == "left" then
          entity.shootPoint.x, entity.shootPoint.y = -15, 12 -- left
        end
      elseif angle == (math.pi * 7)/6 or angle == -0.523599 then
        entity.curAnim = 3 -- up
        if entity.direction == "right" then
          entity.shootPoint.x, entity.shootPoint.y = 32, -20
        elseif entity.direction == "left" then
          entity.shootPoint.x, entity.shootPoint.y = -2, -20
        end
      elseif angle == (math.pi * 5)/6 or angle == math.pi/6 then
        entity.curAnim = 4 -- down
        if entity.direction == "right" then
          entity.shootPoint.x, entity.shootPoint.y = 35, 25
        elseif entity.direction == "left" then
          entity.shootPoint.x, entity.shootPoint.y = -10, 25
        end
      end

      addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, entity.direction, world, angle)
      resetTimer(love.math.random(1.3, 1.5), "shoot", entity.timers) -- add timer between 1.3 and 1.5
      resetTimer(0.1, "secondShot", entity.timers)
    elseif updateTimer(dt, "secondShot", entity.timers) then
      angle = getAngle(player.x, player.y, entity.x, entity.y)

      if angle == math.pi or angle == 0 then
        entity.curAnim = 2 -- left/right
        if entity.direction == "right" then
          entity.shootPoint.x, entity.shootPoint.y = 45, 14 -- right
        elseif entity.direction == "left" then
          entity.shootPoint.x, entity.shootPoint.y = -15, 12 -- left
        end
      elseif angle == (math.pi * 7)/6 or angle == -0.523599 then
        entity.curAnim = 3 -- up
        if entity.direction == "right" then
          entity.shootPoint.x, entity.shootPoint.y = 32, -20
        elseif entity.direction == "left" then
          entity.shootPoint.x, entity.shootPoint.y = -2, -20
        end
      elseif angle == (math.pi * 5)/6 or angle == math.pi/6 then
        entity.curAnim = 4 -- down
        if entity.direction == "right" then
          entity.shootPoint.x, entity.shootPoint.y = 35, 25
        elseif entity.direction == "left" then
          entity.shootPoint.x, entity.shootPoint.y = -10, 25
        end
      end

      addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, entity.direction, world, angle)
      resetTimer(1.6, "secondShot", entity.timers)
    end

    if entity.isDead then entity.playDead = true end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

-- CAMERA-TURRET --
local function cctvBehaviour(dt, entity, world)
    if checkTimer("shoot", entity.timers) == false then
      addTimer(0.0, "shoot", entity.timers)
      addTimer(0.0, "secondShot", entity.timers)
    end

    if updateTimer(dt, "shoot", entity.timers) and entity.isDead ~= true then
      angle = getAngle(player.x, player.y, entity.x, entity.y)

      if angle == (math.pi * 5)/6 or angle == math.pi then --if angle == math.pi or angle == 0 then
        angle = (math.pi * 5)/6
        entity.curAnim = 1 -- down right
        entity.shootPoint.x, entity.shootPoint.y = 13, 18
      elseif angle == math.pi/6 or angle == 0 then
        angle = math.pi/6
        entity.curAnim = 2 -- down left
        entity.shootPoint.x, entity.shootPoint.y = 0, 18
      elseif angle == math.pi/2 then
        entity.curAnim = 3 -- down
        entity.shootPoint.x, entity.shootPoint.y = 8, 18
      end

      addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, entity.direction, world, angle)
      resetTimer(1.5, "shoot", entity.timers) -- add timer
      resetTimer(0.1, "secondShot", entity.timers)
    elseif updateTimer(dt, "secondShot", entity.timers) and entity.isDead ~= true then
      angle = getAngle(player.x, player.y, entity.x, entity.y)

      if angle == (math.pi * 5)/6 or angle == math.pi then --if angle == math.pi or angle == 0 then
        angle = (math.pi * 5)/6
        entity.curAnim = 1 -- down right
        entity.shootPoint.x, entity.shootPoint.y = 13, 18
      elseif angle == math.pi/6 or angle == 0 then
        angle = math.pi/6
        entity.curAnim = 2 -- down left
        entity.shootPoint.x, entity.shootPoint.y = 0, 18
      elseif angle == math.pi/2 then
        entity.curAnim = 3 -- down
        entity.shootPoint.x, entity.shootPoint.y = 8, 18
      end

      addBullet(true, entity.x + entity.shootPoint.x, entity.y + entity.shootPoint.y, entity.direction, world, angle)
      resetTimer(1.6, "secondShot", entity.timers)
    end

    if entity.isDead then
      -- create a timer.. etc
      entity.curAnim = 4
      addTimer(0.8, "death", entity.timers)
      if updateTimer(dt, "death", entity.timers) then
        entity.playDead = true
      end
    end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end


local dictionary = {
  {
    name = "runner",
    hp = 1,
    w = 10,
    h = 42,
    update = runBehaviour,
    specialDraw = nil,
    scale = {x = 1, y = 1, offX = 10, offY = 15},
    sprite = "img/enemies/runner2BIG.png",
    grid = {x = 32, y = 64, w = 96, h = 256},
    shootPoint = {x = 0, y = 0},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(3, 1, '1-3', 2, '1-2', 3), 0.1), -- 1 running
        anim8.newAnimation(grid(3, 3, 1, 4), 0.15), -- 2 dying
      }
      return animations
    end,
    filter = nil,
    collision = nil,
    gravity = 9.8
  },

  {
    name = "grenade",
    hp = 1,
    w = 10,
    h = 10,
    update = grenadeBehaviour,
    specialDraw = nil,
    scale = {x = 1, y = 1, offX = 11, offY = 11},
    sprite = "img/enemies/grenades/grenade.png",
    grid = {x = 32, y = 32, w = 96, h = 64},
    shootPoint = {x = 0, y = 0},
    animations = function(grid)
      local animations = {
        anim8.newAnimation(grid('1-3', 1, 1, 2), 0.1), -- 1 thrown
        anim8.newAnimation(grid('2-3', 2), 0.1), -- 2 exploding
      }
      return animations
    end,
    filter = function(item, other)
      if other.type == "player" or other.type == "block" or other.type == "ground" then
        return 'cross'
      end
    end,
    collision = function(cols, len, entity, world)
      for i = 1, len do
        if cols[i].other.type == "ground" or cols[i].other.type == "block" then
          entity.isDead = true
        elseif cols[i].other.type == "player" then
          cols[i].other.killPlayer()
          entity.isDead = true
        end
      end
    end,
    gravity = 9.8
  },

  {
    name = "prone-shooter",
    hp = 5,
    w = 52,
    h = 12,
    update = proneShooterBehaviour,
    specialDraw = nil,
    scale = {x = 1, y = 1, offX = 6, offY = 20},
    sprite = "img/enemies/prone-shooter/prone-shooterBIG.png",
    grid = {x = 64, y = 32, w = 192, h = 32},
    shootPoint = {x = -20, y = 2},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(1, 1), 0.1), -- 1 static
        anim8.newAnimation(grid(2, 1), .2), -- 2 shooting
        anim8.newAnimation(grid(3, 1), 0.15), -- 3 dying -- should have another empty frame for blinking?
      }
      return animations
    end,
    filter = nil,
    collision = nil,
    gravity = 9.8
  },

  {
    name = "laser-wall",
    hp = 10,
    w = 24,
    h = 20,
    update = laserWallBehaviour,
    specialDraw = laserWallDraw,
    scale = {x = 1, y = 1, offX = 0, offY = 0},
    sprite = "img/enemies/laser-wall/laser-wallBIG.png",
    grid = {x = 64, y = 32, w = 192, h = 160},
    shootPoint = {x = 48, y = 6},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(1, 1), 0.1), -- 1 active
        anim8.newAnimation(grid('1-3', '2-4', '1-2', 5), 0.1, "pauseAtEnd"), -- 2 dying
      }
      return animations
    end,
    filter = nil,
    collision = nil,
    gravity = 0
  },

  {
    name = "wizard",
    hp = 15,
    w = 10,
    h = 35,
    update = wizardBehaviour,
    specialDraw = nil,
    scale = {x = 1, y = 1, offX = 10.75, offY = 20},
    sprite = "img/enemies/wizard/wizardBIG.png",
    grid = {x = 32, y = 64, w = 96, h = 512},
    shootPoint = {x = 16, y = 0},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid('1-2', 1), 0.8), -- 1 floating
        anim8.newAnimation(grid('1-3', '2-5', 1, 1), 0.1, "pauseAtEnd"), -- 2 shooting
        anim8.newAnimation(grid('1-3', '6-7'), 0.1, "pauseAtEnd"), -- 3 dying
        anim8.newAnimation(grid('2-3', 8), 0.1), -- 4 ded
      }
      return animations
    end,
    filter = function(item, other)
      if other.type == "ground" then
        return 'slide'
      --elseif other.type == "player" then
        --return 'cross'
      end
    end,
    collision = function(cols, len, entity, world)
      for i = 1, len do
        if cols[i].other.type == "ground" and entity.isDead and checkTimer("death 2", entity.timers) == false then
          entity.curAnim = 4
          addTimer(0.5, "death 2", entity.timers)
        end

        -- elseif cols[i].other.type == "player" and entity.isDead == false then
          -- cols[i].other.killPlayer
      end
    end, -- put stuff here lol
    gravity = 0
  },

-------- LEGACY ENEMIES BELOW

  {
    name = "shooter/run",
    hp = 1,
    w = 16,
    h = 36,
    update = srBehaviour,
    specialDraw = nil,
    scale = {x = 1, y = 1, offX = 10, offY = 12},
    sprite = "img/enemies/shooter-run/shooter-run.png",
    grid = {x = 34, y = 48, w = 102, h = 144}, -- 27, 35,
    shootPoint = {x = 0, y = 0},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid('1-3', '1-2'), 0.1), -- running 1
        anim8.newAnimation(grid(1, 3), 0.1), -- shooting/stopped 2
        anim8.newAnimation(grid(2, 3), 0.1), -- shoot up 3
        anim8.newAnimation(grid(3, 3), 0.1), -- shoot down 4
        anim8.newAnimation(grid(2, 2), 0.1) -- falling 5
      }
      return animations
    end,
    filter = nil,
    collision = nil,
    gravity = 9.8
  },

  {
    name = "static-shooter",
    hp = 2,
    w = 16,
    h = 36,
    update = sBehaviour,
    specialDraw = nil,
    scale = {x = 1, y = 1, offX = 10, offY = 12},
    sprite = "img/enemies/shooter-run/shooter-run.png",
    grid = {x = 34, y = 48, w = 102, h = 144}, -- 27, 35,
    shootPoint = {x = 0, y = 0},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid('1-3', '1-2'), 0.1), -- running 1
        anim8.newAnimation(grid(1, 3), 0.1), -- shooting/stopped 2
        anim8.newAnimation(grid(2, 3), 0.1), -- shoot up 3
        anim8.newAnimation(grid(3, 3), 0.1), -- shoot down 4
        anim8.newAnimation(grid(2, 2), 0.1) -- falling 5
      }
      return animations
    end,
    filter = nil,
    collision = nil,
    gravity = 9.8
  },

  {
    name = "camera-turret",
    hp = 4,
    w = 16,
    h = 16,
    update = cctvBehaviour,
    specialDraw = nil,
    scale = {x = 0.35, y = 0.35, offX = 7, offY = 5},
    sprite = "img/enemies/camera turret/camera turret.png",
    grid = {x = 64, y = 64, w = 192, h = 256},
    shootPoint = {x = 0, y = 0},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(1, 1), 0.1), -- face left 1
        anim8.newAnimation(grid(2, 1), 0.1), -- face right 2
        anim8.newAnimation(grid(3, 1), 0.1), -- down 3
        anim8.newAnimation(grid('1-3', '2-4'), 0.1, 'pauseAtEnd'), -- dead 4
      }
      return animations
    end,
    filter = nil,
    collision = nil,
    gravity = 0
  },

  {
    name = "target",
    hp = 1,
    w = 56,
    h = 56,
    update = targetBehaviour,
    specialDraw = nil,
    scale = {x = 1, y = 1, offX = 0, offY = 0},
    sprite = "img/enemies/target/target.png",
    grid = {x = 32, y = 32, w = 96, h = 32},
    shootPoint = {x = 0, y = 0},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(1, 1), 0.1),     -- idle - 1
        anim8.newAnimation(grid('2-3', 1), 0.15), -- hit  - 2
      }
      return animations
    end,
    filter = nil,
    collision = nil,
    gravity = 0
  }
}

function getEnemy(newEnemy) -- create some sort of clever dictionary look up function later on..if A > B etc... dictionary stuff
  for i=1, #dictionary do

    if newEnemy.name == dictionary[i].name then
      newEnemy.hp, newEnemy.w, newEnemy.h = dictionary[i].hp, dictionary[i].w, dictionary[i].h
      newEnemy.scale = dictionary[i].scale

      -- functions
      newEnemy.behaviour = dictionary[i].update
      newEnemy.specialDraw = dictionary[i].specialDraw

      -- animation stuff
      newEnemy.spriteSheet = love.graphics.newImage(dictionary[i].sprite)
      newEnemy.spriteGrid = anim8.newGrid(dictionary[i].grid.x, dictionary[i].grid.y, dictionary[i].grid.w, dictionary[i].grid.h, 0, 0, 0)
      newEnemy.animations = dictionary[i].animations(newEnemy.spriteGrid)
      newEnemy.gravity = dictionary[i].gravity

      -- shootPoint
      newEnemy.shootPoint = dictionary[i].shootPoint

      -- filter
      if dictionary[i].filter ~= nil then
        newEnemy.filter = dictionary[i].filter
        newEnemy.collision = dictionary[i].collision
      end

    end
  end
end
