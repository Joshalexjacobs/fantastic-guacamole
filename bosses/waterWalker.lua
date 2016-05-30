-- water walker.lua --

waterWalker = {
  name = "waterWalker",
  type = "block", -- switch to enemy or boss later
  hp = 100,
  maxHP = 100,
  healthBar = 296,
  damageBar = 296,
  w = 75, -- 96
  h = 37,
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
  -- doesnt need gravity
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
    anim8.newAnimation(waterWalker.spriteGrid(1, '7-8'), {0.2, 0.2}), -- 4 squat shoot
    anim8.newAnimation(waterWalker.spriteGrid(1, 6, 1, 1), 0.2, 'pauseAtEnd'), -- 5 squat stand tween to idle
  }

  -- add to world
  world:add(waterWalker, waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)

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

  --if waterWalker.dx < 0 and paceLeft == false then -- deceleration for moving left
    waterWalker.dx = math.min((waterWalker.dx + waterWalker.decel * dt), 0)
  --end

  waterWalker.x, waterWalker.y = world:move(waterWalker, waterWalker.x + waterWalker.dx, waterWalker.y + waterWalker.dy)
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
      addBullet(true, waterWalker.x, waterWalker.y + 58, 1, world, -0.523599 - .5)
      addBullet(true, waterWalker.x, waterWalker.y + 58, 1, world, -0.523599)
      addBullet(true, waterWalker.x, waterWalker.y + 59, 1, world, 0)
      addBullet(true, waterWalker.x, waterWalker.y + 60, 1, world, math.pi/6)
      addBullet(true, waterWalker.x, waterWalker.y + 61, 1, world, math.pi/6 + .5)

      resetTimer(0.4, "squat shot", waterWalker.timers)
      waterWalker.squatShot = waterWalker.squatShot + 1
    elseif waterWalker.squatShot >= 4 and checkTimer("squat end", waterWalker.timers) == false then
      waterWalker.animations[4]:pauseAtEnd()
      addTimer(0.3, "squat end", waterWalker.timers)
    end

    if updateTimer(dt, "squat end", waterWalker.timers) then -- and checkTimer("begin pace", waterWalker.timers) == false then
      waterWalker.curAnim = 5
      --addTimer(0.3, "begin pace", waterWalker.timers)
    end


    -- PACE AND SHOOT --

  end

  -- elseif stage 2...

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
  love.graphics.rectangle("line", waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)

  waterWalker.animations[waterWalker.curAnim]:draw(waterWalker.spriteSheet, waterWalker.x, waterWalker.y, 0, 1, 1, 7, 15)
  love.graphics.print(waterWalker.hp, waterWalker.x, waterWalker.y)
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
