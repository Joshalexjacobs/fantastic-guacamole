-- player.lua --

-- Player Class: --
local player = {
  name = "player",
  x = 375,
  y = 250,
  w = 24, --32
  h = 72, --64
  dx = 0,
  dy = 0,
  speed = 200,
  initVel = 6,
  termVel = -3,
  isJumping = false,
  isGrounded = false,
  prevDir = 1, -- used for flipping animations
  lastDir = 1, -- 1 player is facing right, 0 player is facing left
  --controls = "right", -- can be up, upright, upleft, right, left, down, downright, and downleft
  controls = 0,
  spriteSheet = nil,
  spiteGrid = nil,
  animations = {},
  curAnim = 1,
}

local midpoint

function loadPlayer(world, anim8)
  world:add(player, player.x, player.y, player.w, player.h)
  midpoint = windowWidth / 2 -- calculate midpoint

  -- load player sprites
  player.spriteSheet = love.graphics.newImage('img/player/player.png')
  player.spriteGrid = anim8.newGrid(34, 48, 102, 432, 0, 0, 0)

  player.animations = {
    anim8.newAnimation(player.spriteGrid('2-3', 7), 0.6), -- 1 idle
    anim8.newAnimation(player.spriteGrid('1-3', '1-2'), 0.1), -- 2 idleRun
    anim8.newAnimation(player.spriteGrid('1-3', '3-4'), 0.1), -- 3 horizontalShotRun
    anim8.newAnimation(player.spriteGrid('1-3', '5-6'), 0.1), -- 4 diagShotRun
    anim8.newAnimation(player.spriteGrid(1, 7), 0.1), -- 5 lookUp
    anim8.newAnimation(player.spriteGrid('1-3', 8, 1, 9), 0.1) -- 6 jump/fall
  }
end

-- Player Globals: --
local shootTimerMax = 0.2
local shootTimer = 0

local animTimerMax = 0.5
local animTimer = 0

local jumpTimerMax = 0.4
local jumpTimer = jumpTimerMax

local gravity, damping, maxVel, decel = 9.8, 0.5, 6.0, 8

local playerFilter = function(item, other)
  if other.name == "enemy" then
    return 'slide'
  elseif other.name == "block" then
    return 'slide'
  end
end

local function playerInput(dt)

  -- left/right movement
  if love.keyboard.isDown("d") or dPadRight() then
    player.dx = player.speed * dt
    player.lastDir = 1

    if love.keyboard.isDown("w") then
      player.controls = (math.pi * 5)/4
    elseif love.keyboard.isDown("s") then
      player.controls = (math.pi * 3)/4
    else
      player.controls = math.pi
    end

  elseif love.keyboard.isDown("a") or dPadLeft() then
    player.dx = -player.speed * dt
    player.lastDir = 0

    if love.keyboard.isDown("w") then
      player.controls = -0.785398
    elseif love.keyboard.isDown("s") then
      player.controls = math.pi/4
    else
      player.controls = 0
    end

  elseif love.keyboard.isDown("w") then
    player.controls = (math.pi * 3)/2

  elseif love.keyboard.isDown("s") then
    player.controls = math.pi/2

  else
    if player.lastDir == 1 then player.controls = math.pi
    else player.controls = 0 end
  end

  -- deceleration
  if (dPadRight() == false or love.keyboard.isDown("d") == false) and player.dx > 0 then
    player.dx = math.max((player.dx - decel * dt), 0)
  elseif (dPadLeft() == false or love.keyboard.isDown("a") == false) and player.dx < 0 then
    player.dx = math.min((player.dx + decel * dt), 0)
  end

  -- jump --
  if (love.keyboard.isDown('n') and not player.isJumping and player.isGrounded) or (pressX() and not player.isJumping and player.isGrounded) then -- when the player hits jump
    player.isJumping = true
    player.isGrounded = false
    player.dy = -player.initVel -- 6 is our current initial velocity
    jumpTimer = jumpTimerMax
  elseif (love.keyboard.isDown('n') and jumpTimer > 0 and player.isJumping) or (pressX() and jumpTimer > 0 and player.isJumping) then
    player.dy = player.dy + (-0.5)
  elseif (not love.keyboard.isDown('n') and player.isJumping) or (not pressX() and player.isJumping) then -- if the player releases the jump button mid-jump...
    if player.dy < player.termVel then -- and if the player's velocity has reached the minimum velocity (minimum jump height)...
      player.dy = player.termVel -- terminate the jump
    end
    player.isJumping = false
  end

end

function updatePlayer(dt, world) -- Update Player Movement [http://2dengine.com/doc/gs_platformers.html] --
  -- MOVEMENT --
  playerInput(dt)

  -- this block locks in our velocity to maxVel --
  local v = math.sqrt(player.dx^2 + player.dy^2)
  if v > maxVel then
    local vs = maxVel/v
    player.dx = player.dx*vs
    player.dy = player.dy*vs
  end

  -- these 2 lines handle damping (aka friction) --
  player.dx = player.dx / (1 + damping * dt)
  player.dy = player.dy / (1 + damping * dt)

  -- decrement jumpTimer --
  jumpTimer = jumpTimer - (1 * dt)

  -- constant force of gravity --
  player.dy = player.dy + (gravity * dt)

  if player.dx ~= 0 or player.dy ~= 0 then
    local cols
    player.x, player.y, cols, len = world:move(player, player.x + player.dx, player.y + player.dy, playerFilter)
    if len > 0 and not player.isJumping then -- check if the player is colliding with the ground
      player.isGrounded = true
    else
      player.isGrounded = false
    end
  end

  -- SHOOTING --
  -- decrement shootTimer and animTimer--
  if shootTimer > 0 then shootTimer = shootTimer - (1 * dt) end

  if animTimer > 0 then animTimer = animTimer - (1 * dt) end

  -- player shoot -- !!! this must be modified in the future to force the player to tap the circle/shoot button
  if (pressCircle() or love.keyboard.isDown('m')) and shootTimer <= 0 then
    --[[if player.lastDir == 1 then
      addBullet(player.x + 40, player.y + player.w - 10, player.lastDir, world, player.controls)
    else
      addBullet(player.x - 15, player.y + player.w - 10, player.lastDir, world, player.controls)
    end]]
    addBullet(player.x + 40, player.y + player.w - 10, player.lastDir, world, player.controls)

    shootTimer = shootTimerMax
    animTimer = animTimerMax
  end

  -- ANIMATIONS --
  -- flip animations based on player's direction --
  if player.lastDir ~= player.prevDir then
    for i=1, table.getn(player.animations) do
      player.animations[i]:flipH()
      player.prevDir = player.lastDir
    end
  end

  -- set the player's current animation based on their movement
  if player.isJumping or not player.isGrounded then
    player.curAnim = 6 -- [JUMPING]
  elseif player.dx <= 1.5 and player.dx >= -1.5 and love.keyboard.isDown('w') == false
    then player.curAnim = 1 -- [IDLE]
  elseif player.dx <= 1.5 and player.dx >= -1.5 and love.keyboard.isDown('w')
    then player.curAnim = 5 -- [LOOKING UP]
  elseif animTimer <= 0 then
    player.curAnim = 2 -- [IDLE RUN]
    player.animations[3]:update(dt) -- update the shotting+running anim at the same time
    player.animations[4]:update(dt)
  elseif love.keyboard.isDown('w') == false and animTimer > 0 then
    player.curAnim = 3 -- [SHOOT N RUN HORIZONTAL]
    player.animations[2]:update(dt) -- update the running and not shooting anim at the same time
    player.animations[4]:update(dt)
  elseif animTimer > 0 then
    player.curAnim = 4-- [SHOOT N RUN DIAGONAL]
    player.animations[3]:update(dt)
    player.animations[2]:update(dt)
  end

  -- update the player's current animation --
  player.animations[player.curAnim]:update(dt)
end

function checkScreenMove(left)
  if player.x + player.w / 2 > midpoint + left then
    return true
  else
    return false
  end
end

function drawPlayer()
  setColor({255, 255, 255, 255}) -- sets the player's color
    love.graphics.rectangle("line", player.x, player.y, player.w, player.h) -- *KEEP* will most likely become hit box!
    player.animations[player.curAnim]:draw(player.spriteSheet, player.x, player.y, 0, 2.5, 2.5, 11, 18.5) -- 8 and 33 are the offsets for scale 2....10 and 43 for scale 3
end

--[[
local function checkAngle(angle)
  if angle < 22.5 and angle > -22.5 then-- right
    return 0
  elseif angle < -22.5 and angle > -67.5 then -- top right
    return (7*math.pi)/4
  elseif angle < -67.5 and angle > -112.5 then -- up
    return (3*math.pi)/2 (pi/2)
  elseif angle < -112.5 and angle > -157.5 then -- top left
    return (5*math.pi)/4
  elseif angle > 157.5 or angle < -157.5 then -- left
    return math.pi
  elseif angle < 157.5 and angle > 112.5 then -- bottom left
    return (3*math.pi)/4
  elseif angle < 112.5 and angle > 67.5 then -- down
    return math.pi/2 (-pi/2)
  elseif angle < 67.5 and angle > 22.5 then -- bottom right
    return math.pi/4
  end
end
]]

return player
