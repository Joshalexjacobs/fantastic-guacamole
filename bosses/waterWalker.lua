-- water walker.lua --

waterWalker = {
  name = "waterWalker",
  type = "block", -- switch to enemy or boss later
  filter = function(item, other)
    return 'cross'
  end,
  hp = 100,
  maxHP = 100,
  healthBar = 296,
  damageBar = 296,
  w = 75, -- 96
  h = 50,
  x = 2605, -- 2605
  y = 40, -- 35
  dx = 0,
  dy = 0,
  speed = 70, -- 50
  decel = 10, -- 8
  image = "img/bosses/water walker.png",
  spriteSheet = nil,
  spriteGrid = nil,
  animations = {},
  curAnim = 1,
  timers = {},
  stage = 0, -- 0 entrance, 1, 2, 3 death
  isDead = false,
  paceLeft = false,
  paceRight = false,
  squatShot = 0,
  paceShot = 0
}


local backZone = {x = 2530, y = 0, w = 80, h = 160}
local frontZone = {x = 2445, y = 0, w = 5, h = 160}

-- when the player touches the enemy they die
local legs = {
  name = "waterWalker legs",
  type = "invisible wall",
  filter = function(item, other)
    return 'cross'
  end,
  x = 2615,
  y = 60,
  w = 20,
  h = 100
}

function waterWalker:load(world)
  print("loaded waterWalker")

  -- load spritesheet
  waterWalker.spriteSheet = love.graphics.newImage(waterWalker.image)
  waterWalker.spriteGrid = anim8.newGrid(96, 128, 96, 1024, 0, 0, 0)

  -- load animations
  waterWalker.animations = {             -- col, row
    anim8.newAnimation(waterWalker.spriteGrid(1, 1), 0.1), -- 1 idle
    anim8.newAnimation(waterWalker.spriteGrid(1, '2-5'), {0.2, 0.1, 0.2, 0.1}), -- 2 walk
    anim8.newAnimation(waterWalker.spriteGrid(1, '6-7'), {0.2, 0.1}, 'pauseAtEnd'), -- 3 squat tween
    anim8.newAnimation(waterWalker.spriteGrid(1, '7-8'), {0.1, 0.1}), -- 4 squat shoot
    anim8.newAnimation(waterWalker.spriteGrid(1, 6, 1, 1), 0.2, 'pauseAtEnd'), -- 5 squat stand tween to idle
    anim8.newAnimation(waterWalker.spriteGrid(1, '5-2'), {0.2, 0.1, 0.2, 0.1}), -- 6 walk backwards
  }

  -- add to world
  if world:hasItem(waterWalker) then
    world:remove(waterWalker)
  end

  world:add(waterWalker, waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)

  -- add legs to world
  if world:hasItem(legs) then
    world:remove(legs)
  end

  world:add(legs, legs.x, legs.y, legs.w, legs.h) -- leg stuff

  -- add any needed timers
  addTimer(0.0, "damageBar", waterWalker.timers)
end

function waterWalker:update(dt, world)
  -- once activated start entrance animation
  if checkTimer("entrance", waterWalker.timers) == false then
    addTimer(1.75, "entrance", waterWalker.timers) -- start entrance timer -- 2.0
    waterWalker.curAnim = 2
  elseif updateTimer(dt, "entrance", waterWalker.timers) == false then
    waterWalker.dx = -waterWalker.speed * dt
  elseif updateTimer(dt, "entrance", waterWalker.timers) == true and waterWalker.type ~= "boss" then
    waterWalker.type = "boss"
    waterWalker.animations[2]:pauseAtEnd()
    addTimer(0.3, "end entrance", waterWalker.timers)
  elseif updateTimer(dt, "end entrance", waterWalker.timers) and waterWalker.stage == 0 then
    waterWalker.curAnim = 1
    waterWalker.stage = 1
    addTimer(0.3, "begin stage 1", waterWalker.timers)
  end


  if waterWalker.paceLeft == false and waterWalker.dx < 0 then -- deceleration
    waterWalker.dx = math.min((waterWalker.dx + waterWalker.decel * dt), 0)
  elseif waterWalker.paceRight == false and waterWalker.dx > 0 then
    waterWalker.dx = math.min((waterWalker.dx - waterWalker.decel * dt), 0)
  end

  waterWalker.x, waterWalker.y = world:move(waterWalker, waterWalker.x + waterWalker.dx, waterWalker.y + waterWalker.dy, waterWalker.filter)
  legs.x, legs.y = world:move(legs, legs.x + waterWalker.dx, legs.y + waterWalker.dy, legs.filter)
  -- END OF MOVEMENT --

  if updateTimer(dt, "begin stage 1", waterWalker.timers) and checkTimer("squat attack", waterWalker.timers) == false then -- only called once after entrance sequence
    waterWalker.curAnim = 3
    addTimer(0.5, "squat attack", waterWalker.timers)
  end

  if waterWalker.stage == 1 then
    -- SQUAT ATTACK --

    if updateTimer(dt, "squat attack", waterWalker.timers) and checkTimer("squat shot", waterWalker.timers) == false then

      waterWalker.curAnim = 4
      addTimer(0.2, "squat shot", waterWalker.timers)
    elseif updateTimer(dt, "squat shot", waterWalker.timers) and waterWalker.squatShot < 4 then
      deviation = love.math.random(-1, 1) * 0.03
      addBullet(true, waterWalker.x, waterWalker.y + 58, 1, world, -0.523599 - .5 + deviation)
      addBullet(true, waterWalker.x, waterWalker.y + 58, 1, world, -0.523599 + deviation)
      addBullet(true, waterWalker.x, waterWalker.y + 59, 1, world, 0 + deviation)
      addBullet(true, waterWalker.x, waterWalker.y + 60, 1, world, math.pi/6 + deviation)
      addBullet(true, waterWalker.x, waterWalker.y + 61, 1, world, math.pi/6 + .5 + deviation)

      resetTimer(0.2, "squat shot", waterWalker.timers)
      waterWalker.squatShot = waterWalker.squatShot + 1
    elseif waterWalker.squatShot >= 4 and checkTimer("squat end", waterWalker.timers) == false then
      waterWalker.animations[4]:pauseAtEnd()

      world:remove(waterWalker)
      world:add(waterWalker, waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)

      addTimer(0.3, "squat end", waterWalker.timers)
    end

    if updateTimer(dt, "squat end", waterWalker.timers) and checkTimer("begin pace", waterWalker.timers)  == false then
      waterWalker.curAnim = 5
      addTimer(0.3, "begin pace", waterWalker.timers)
    end


    -- PACE AND SHOOT --
    if updateTimer(dt, "begin pace", waterWalker.timers) and checkTimer("pace move", waterWalker.timers) == false then
       if love.math.random(0, 1) == 1 then -- random num between 1 and 0
         if waterWalker.x + waterWalker.w / 2 < backZone.x then
           waterWalker.paceRight = true
         else
            waterWalker.paceLeft = true
         end
       else
         if waterWalker.x > frontZone.x then
           waterWalker.paceLeft = true
         else
           waterWalker.paceRight = true
         end
       end

       addTimer(0.7, "pace move", waterWalker.timers)
    elseif updateTimer(dt, "pace move", waterWalker.timers) == false then
      if waterWalker.paceRight then
        waterWalker.animations[6]:resume()
        waterWalker.curAnim = 6
        waterWalker.dx = waterWalker.speed * dt
      elseif waterWalker.paceLeft then
        waterWalker.animations[2]:resume()
        waterWalker.curAnim = 2
        waterWalker.dx = -waterWalker.speed * dt
      end
    elseif updateTimer(dt, "pace move", waterWalker.timers) == true and checkTimer("pace shoot", waterWalker.timers) == false then
      if waterWalker.paceLeft then waterWalker.animations[2]:pauseAtEnd()
      else waterWalker.animations[6]:pauseAtEnd() end

      waterWalker.paceLeft, waterWalker.paceRight = false, false
      --addTimer(0.5, "pace shoot", waterWalker.timers)


      addTimer(0.0, "restart stage 1", waterWalker.timers) -- temporary -- used to restart stage 1 fight cycle
    end
  end


  -- for cycling through stage 1
  if updateTimer(dt, "restart stage 1", waterWalker.timers) then
    resetTimer(0.3, "begin stage 1", waterWalker.timers)

    -- delete squat timers
    deleteTimer("squat attack", waterWalker.timers)
    deleteTimer("squat shot", waterWalker.timers)
    deleteTimer("squat end", waterWalker.timers)
    waterWalker.squatShot = 0
    waterWalker.animations[3]:gotoFrame(1)
    waterWalker.animations[4]:resume()
    waterWalker.animations[5]:gotoFrame(1)

    -- delete pace timers
    deleteTimer("begin pace", waterWalker.timers)
    deleteTimer("pace move", waterWalker.timers)
    waterWalker.animations[2]:resume()
    waterWalker.animations[6]:resume()

    deleteTimer("restart stage 1", waterWalker.timers)
    waterWalker.curAnim = 1
  end

  -- elseif stage 2...

  -- waterWalker death code might be on my pc... or on github? I shouldn't push/pull until i know for sure

  -- if dead then start death anim and death anim timer
  -- if death anim timer is finished end level

  -- update healthbar
  if updateTimer(dt, "damageBar", waterWalker.timers) then
    --waterWalker.damageBar = waterWalker.healthBar
    if waterWalker.damageBar >= waterWalker.healthBar then
      waterWalker.damageBar = waterWalker.damageBar - 50 * dt -- 50 is damageBar decrease speed
    end
  end

  waterWalker.animations[waterWalker.curAnim]:update(dt)
end

function waterWalker:draw()
  --love.graphics.rectangle("line", waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)
  love.graphics.rectangle("line", waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)


  waterWalker.animations[waterWalker.curAnim]:draw(waterWalker.spriteSheet, waterWalker.x, waterWalker.y, 0, 1, 1, 7, 15)
  love.graphics.print(waterWalker.hp, waterWalker.x, waterWalker.y)

  --love.graphics.rectangle("line", legs.x, legs.y, legs.w, legs.h)

  --love.graphics.rectangle("line", backZone.x, backZone.y, backZone.w, backZone.h)
  --love.graphics.rectangle("line", frontZone.x, frontZone.y, frontZone.w, frontZone.h)

end

function waterWalker:drawHealth()
  if waterWalker.hp < waterWalker.maxHP then
    newHP = waterWalker.hp / waterWalker.maxHP
    waterWalker.healthBar = newHP * waterWalker.healthBar
    waterWalker.maxHP = waterWalker.hp
    resetTimer(0.3, "damageBar", waterWalker.timers)
  end

  setColor({0, 0, 0, 255}) -- black
  love.graphics.rectangle("fill", 10, 170, 300, 7) -- background/border

  setColor({200, 150, 0, 255}) -- yellow
  love.graphics.rectangle("fill", 12, 172, waterWalker.damageBar, 4) -- damage dealt

  setColor({255, 0, 0, 255}) -- red
  love.graphics.rectangle("fill", 12, 172, waterWalker.healthBar, 4) -- boss health

  setColor({255, 255, 255, 255})
end
