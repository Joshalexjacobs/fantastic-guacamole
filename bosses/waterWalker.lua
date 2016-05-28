-- water walker.lua --

waterWalker = {
  name = "waterWalker",
  type = "block", -- switch to enemy or boss later
  hp = 10, -- 100
  maxHP = 10,
  healthBar = 296,
  damageBar = 296,
  w = 75, -- 96
  h = 37,
  x = 2605,
  y = 35,
  dx = 0,
  dy = 0,
  speed = 50,
  decel = 8, -- 8
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
  -- doesnt need gravity
}

function waterWalker:load(world)
  print("loaded waterWalker")

  -- load spritesheet
  waterWalker.spriteSheet = love.graphics.newImage(waterWalker.image)
  waterWalker.spriteGrid = anim8.newGrid(96, 128, 96, 128, 0, 0, 0)

  -- load animations
  waterWalker.animations = {                -- col, row
    anim8.newAnimation(waterWalker.spriteGrid(1, 1), 0.1), -- 1 idle
  }

  -- add to world
  world:add(waterWalker, waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)

  -- add any needed timers
  addTimer(0.0, "damageBar", waterWalker.timers)
end

function waterWalker:update(dt, world)
  -- once activated start entrance animation
  if checkTimer("entrance", waterWalker.timers) == false then
    addTimer(2.0, "entrance", waterWalker.timers) -- start entrance timer
  elseif updateTimer(dt, "entrance", waterWalker.timers) == false then
    waterWalker.dx = -waterWalker.speed * dt
  elseif updateTimer(dt, "entrance", waterWalker.timers) == true and waterWalker.tpye ~= "enemy" then
    waterWalker.type = "enemy"
  end

  --if waterWalker.dx < 0 and paceLeft == false then -- deceleration for moving left
    waterWalker.dx = math.min((waterWalker.dx + waterWalker.decel * dt), 0)
  --end

  waterWalker.x, waterWalker.y = world:move(waterWalker, waterWalker.x + waterWalker.dx, waterWalker.y + waterWalker.dy)

  --print(waterWalker.dx)

  --  if stage 1...

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
  --love.graphics.rectangle("line", waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)

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
