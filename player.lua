-- player.lua --

-- Player Class: --
local player = {
  type = "player", -- or "invincible"
  lives = 6,
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
  isDead = false,
  prevDir = 1, -- used for mirroring animations
  lastDir = 1, -- 1 player is facing right, 0 player is facing left
  controls = {0, {x = 0, y = 0}, true},
  spriteSheet = nil,
  spiteGrid = nil,
  animations = {},
  curAnim = 1,
  timers = {},
  filter = function(item, other)
    if other.type == "enemy" then
      return 'cross'
    elseif other.type == "block" or other.type == "ground" then
      return 'slide'
    elseif other.type == "bullet" then
      return 'cross'
    end
  end,
  respawnFilter = function(item, other)
    if other.type == "block" or other.type == "ground" then
      return 'slide'
    end
  end
}

respawnTimer = 0
respawnTimerMax = 1.0 -- 1 second

invinceTimer = 0
invinceTimerMax = 1.0

-- player functions
function player.killPlayer(world)
  if respawnTimer <= 0 then
    player.lives = player.lives - 1
    respawnTimer = respawnTimerMax
    player.isDead = true

    player.type = "invincible"
  end
end

-- general functions

local midpoint

function loadPlayer(world)
  world:add(player, player.x, player.y, player.w, player.h)
  midpoint = windowWidth / 2 -- calculate midpoint

  -- load player sprites
  player.spriteSheet = love.graphics.newImage('img/player/player.png')
  player.spriteGrid = anim8.newGrid(34, 48, 102, 480, 0, 0, 0) --432

  player.animations = {
    anim8.newAnimation(player.spriteGrid('2-3', 7), 0.6), -- 1 idle
    anim8.newAnimation(player.spriteGrid('1-3', '1-2'), 0.1), -- 2 idleRun
    anim8.newAnimation(player.spriteGrid('1-3', '3-4'), 0.1), -- 3 horizontalShotRun
    anim8.newAnimation(player.spriteGrid('1-3', '5-6'), 0.1), -- 4 diagShotRun
    anim8.newAnimation(player.spriteGrid(1, 7), 0.1), -- 5 lookUp
    anim8.newAnimation(player.spriteGrid('1-3', 8, 1, 9), 0.1), -- 6 jump/fall
    anim8.newAnimation(player.spriteGrid('2-3', 9, 1, 10), 0.1 ), -- 7 diagShotRunDown
    anim8.newAnimation(player.spriteGrid(3, 10), 0.1 ) -- 8 blinking
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

local function playerInput(dt, world)

  -- left/right movement
  if love.keyboard.isDown("d") or dPadRight() then
    player.dx = player.speed * dt
    player.lastDir = 1

    if love.keyboard.isDown("w") then -- UpRight
      player.controls[1] = (math.pi * 7)/6
      player.controls[2].x, player.controls[2].y = 32, -20
      player.controls[3] = true
    elseif love.keyboard.isDown("s") then -- DownRight
      player.controls[1] = (math.pi * 5)/6
      player.controls[2].x, player.controls[2].y = 35, 25
      player.controls[3] = true
    else
      player.controls[1] = math.pi -- Right
      player.controls[2].x, player.controls[2].y = 45, 14
      player.controls[3] = true
    end

  elseif love.keyboard.isDown("a") or dPadLeft() then
    player.dx = -player.speed * dt
    player.lastDir = 0

    if love.keyboard.isDown("w") then -- UpLeft
      player.controls[1] = -0.523599
      player.controls[2].x, player.controls[2].y = -2, -20
      player.controls[3] = true
    elseif love.keyboard.isDown("s") then -- DownLeft
      player.controls[1] = math.pi/6
      player.controls[2].x, player.controls[2].y = -10, 25 -- -10
      player.controls[3] = true
    else
      player.controls[1] = 0 -- Left
      player.controls[2].x, player.controls[2].y = -15, 14
      player.controls[3] = true
    end

  elseif love.keyboard.isDown("w") then -- Up
    player.controls[1] = (math.pi * 3)/2
    player.controls[3] = true
    if player.lastDir == 1 then
      player.controls[2].x, player.controls[2].y = 17, -40
    else
      player.controls[2].x, player.controls[2].y = 11, -40
    end

  elseif love.keyboard.isDown("s") then -- Down
    player.controls[1] = math.pi/2
    player.controls[2].x, player.controls[2].y = 15, 25
    if player.isJumping or not player.isGrounded then player.controls[3] = true
    else player.controls[3] = false end

  else -- else player isn't hitting any of these keys so default them back to left/right
    if player.lastDir == 1 then
      player.controls[1] = math.pi
      player.controls[2].x, player.controls[2].y = 40, 14
      player.controls[3] = true
    else
      player.controls[1] = 0
      player.controls[2].x, player.controls[2].y = -15, 14
      player.controls[3] = true
    end
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

  -- DEATH/LIFE/DEATH --

  if player.isDead then
    respawnTimer = respawnTimer - (1 * dt) -- decrement respawnTimer

    if respawnTimer <= 0 and player.lives > 0 then
      -- revive player
      player.isDead = false

      -- start invincibility timer
      invinceTimer = invinceTimerMax
    end

    --do return end -- skip rest of updatePlayer
  end

  -- decrement invincibility timer
  if invinceTimer > 0 then invinceTimer = invinceTimer - (1 * dt) end
  if invinceTimer <= 0 and player.type ~= "player" then player.type = "player" end

  -- MOVEMENT --
  playerInput(dt, world)

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

    if player.lives > 0 then
      -- check if player has temporary invincibility
      if player.type == "invincible" then player.x, player.y, cols, len = world:move(player, player.x + player.dx, player.y + player.dy, player.respawnFilter)
      else player.x, player.y, cols, len = world:move(player, player.x + player.dx, player.y + player.dy, player.filter) end

      if len > 0 then
        for i = 1, len do
          if cols[i].other.type == "ground" then
            player.isGrounded = true
            break
          end
        end
      else
        player.isGrounded = false
      end
    end

  end


  -- SHOOTING --
  -- decrement shootTimer and animTimer--
  if shootTimer > 0 then shootTimer = shootTimer - (1 * dt) end

  if animTimer > 0 then animTimer = animTimer - (1 * dt) end

  -- player shoot -- !!! this must be modified in the future to force the player to tap the circle/shoot button
  if (pressCircle() or love.keyboard.isDown('m')) and shootTimer <= 0 then
    -- if player is grounded...
    if player.controls[3] then
      --print(player.controls[1])
      addBullet(false, player.x + player.controls[2].x, player.y + player.controls[2].y, player.lastDir, world, player.controls[1])
    end

    shootTimer = shootTimerMax
    animTimer = animTimerMax
  end

  -- ANIMATIONS --
  -- flip animations based on player's direction --
  if player.lastDir ~= player.prevDir then
    for i=1, table.getn(player.animations) do
      player.animations[i]:flipH()
    end
    player.prevDir = player.lastDir
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
    player.animations[7]:update(dt)

  elseif animTimer > 0 and love.keyboard.isDown('s') then
    player.curAnim = 7 -- [SHOOT N RUN DIAGONAL DOWN]
    player.animations[3]:update(dt)
    player.animations[2]:update(dt)
    player.animations[4]:update(dt)
  elseif animTimer > 0 and love.keyboard.isDown('w') then
    player.curAnim = 4-- [SHOOT N RUN DIAGONAL]
    player.animations[3]:update(dt)
    player.animations[2]:update(dt)
    player.animations[7]:update(dt)
  elseif animTimer > 0 then
    player.curAnim = 3 -- [SHOOT N RUN HORIZONTAL]
    player.animations[2]:update(dt) -- update the running and not shooting anim at the same time
    player.animations[4]:update(dt)
    player.animations[7]:update(dt)
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
    --love.graphics.rectangle("line", player.x, player.y, player.w, player.h)

    if player.isDead == false then
      setColor({255, 255, 255, 255})
      player.animations[player.curAnim]:draw(player.spriteSheet, player.x, player.y, 0, 2.5, 2.5, 11, 18.5) -- SCALED UP 2.5, 11 and 18.5 are offsets
    elseif player.lives > 0 then
      setColor({255, 255, 255, 25})
      player.animations[player.curAnim]:draw(player.spriteSheet, player.x, player.y, 0, 2.5, 2.5, 11, 18.5) -- SCALED UP 2.5, 11 and 18.5 are offsets
      setColor({255, 255, 255, 255})
    end

end

return player
