-- player.lua --

-- Player Class: --
local player = {
  type = "player", -- or "invincible" -- or "invincibleProne"
  lives = 3,
  x = 0,
  y = 130,
  w = 10,
  h = 42,
  dx = 0,
  dy = 0,
  speed = 80,
  initVel = 3,
  termVel = -3,
  isJumping = false,
  jumpLock = false,
  shootLock = false,
  isGrounded = false,
  isDead = false,
  prevDir = 1, -- used for mirroring animations
  lastDir = 1, -- 1 player is facing right, 0 player is facing left
  isProne = false,
  shootPoint = {x = 0, y = 0},
  controls = {0, {x = 0, y = 0}, true},
  spriteSheet = nil,
  spriteSheetHorizontal = nil,
  spriteGrid = nil,
  spriteGirdHorizontal = nil,
  animations = {},
  curAnim = 1,
  timers = {},
  filter = function(item, other)
    if other.type == "enemy" then
      return 'cross'
    elseif other.type == "block" or other.type == "ground" or other.type == "boss" then
      return 'slide'
    elseif other.type == "bullet" then
      return 'cross'
    end
  end,
  respawnFilter = function(item, other)
    if other.type == "block" or other.type == "ground" then
      return 'slide'
    end
  end,
  killPlayer = function(world)
    if respawnTimer <= 0 then
      player.lives = player.lives - 1
      respawnTimer = respawnTimerMax
      player.isDead = true

      if player.isProne then
        player.isProne = false
      end

      if player.lastDir == 1 then
        player.dx = -2
        player.dy = -5
      else
        player.dx = 2
        player.dy = -5
      end

      player.curAnim = 8
      player.isGrounded = false
      player.type = "invincible"
    end
  end
}

-- rects
local proneRect = {
  w = 40,
  h = 10,
  x = 0,
  y = 0,
  offX = -18,
  offY = 35,
  filter = function(item, other)
    if other.type == "enemy" or other.type == "bullet" then
      return 'cross'
    end
  end,
  type = "player",
  killPlayer = player.killPlayer
}

local playerSounds = {
  shoot = nil
}

respawnTimer = 0
respawnTimerMax = 2.0 -- 4 seconds

invinceTimer = 0
invinceTimerMax = 2.0

--------- GENERAL FUNCTIONS ---------

function loadPlayer(world, playerSkinV, playerSkinH)
  world:add(player, player.x, player.y, player.w, player.h)

  -- load player sprites
  player.spriteSheet = love.graphics.newImage(playerSkinV)
  player.spriteSheetHorizontal = love.graphics.newImage(playerSkinH)

  player.spriteGrid = anim8.newGrid(32, 64, 96, 960, 0, 0, 0) -- vertical grid
  player.spriteGirdHorizontal = anim8.newGrid(64, 32, 192, 64, 0, 0, 0) -- horizontal grid

  player.animations = {                -- col, row
    anim8.newAnimation(player.spriteGrid('1-2', 1), 0.6), -- 1 idle
    anim8.newAnimation(player.spriteGrid('1-3', '3-4'), 0.1), -- 2 idleRun
    anim8.newAnimation(player.spriteGrid('1-3', '5-6'), 0.1), -- 3 horizontalShotRun
    anim8.newAnimation(player.spriteGrid('1-3', '7-8'), 0.1), -- 4 diagShotRun
    anim8.newAnimation(player.spriteGrid(1, 11), 0.1), -- 5 lookUp
    anim8.newAnimation(player.spriteGrid(3, 11, '1-3', 12), 0.1), -- 6 jump/fall
    anim8.newAnimation(player.spriteGrid('1-3', '9-10'), 0.1 ), -- 7 diagShotRunDown
    anim8.newAnimation(player.spriteGrid('1-3', '13-14'), 0.1, "pauseAtEnd"), -- 8 dead fall
    anim8.newAnimation(player.spriteGirdHorizontal(3, 1, '1-3', 2), 0.1 ), -- 9 idle shoot anim
    -- look up shoot anim,
    anim8.newAnimation(player.spriteGirdHorizontal('1-2', 2), 0.1 ), -- 9 dead -- 10
    anim8.newAnimation(player.spriteGirdHorizontal(1, 1), 0.1 ), -- 10 prone -- 11
    anim8.newAnimation(player.spriteGirdHorizontal(2, 1), 0.1 ), -- 11 prone-shot -- 12
  }

  playerSounds.shoot = love.audio.newSource("sound/player sound/machinegunBASS.wav", static)
  --playerSounds.shoot:setVolume(10)
  playerSounds.shoot:setVolume(0.1)

  --------- LOAD PLAYER TIMERS ---------
  addTimer(0.0, "proneShot", player.timers)
  addTimer(0.0, "idleShot", player.timers)
end

--------- PLAYER GLOBAL ---------
local shootTimerMax = 0.2 -- 0.15
local shootTimer = 0

local animTimerMax = 0.2
local animTimer = 0

local jumpTimerMax = 0.2 -- 0.4
local jumpTimer = jumpTimerMax

local gravity, damping, maxVel, decel = 9.8, 0.5, 6.0, 8

local function playerInput(dt, world)

  -- left/right movement
  if love.keyboard.isDown("d") or dPadRight() and player.isDead == false then
    player.isProne = false
    player.dx = player.speed * dt
    player.lastDir = 1

    if love.keyboard.isDown("w") then    -- UpRight
      player.shootPoint.x, player.shootPoint.y = player.x + 50, player.y - 50
      player.controls[2].x, player.controls[2].y = 15, -3
      player.controls[3] = true
    elseif love.keyboard.isDown("s") then -- DownRight
      player.shootPoint.x, player.shootPoint.y = player.x + 50, player.y + 50
      player.controls[2].x, player.controls[2].y = 16, 17
      player.controls[3] = true
    else                                   -- Right
      player.shootPoint.x, player.shootPoint.y = player.x + 50, player.y
      player.controls[2].x, player.controls[2].y = 21, 9
      player.controls[3] = true
    end

  elseif love.keyboard.isDown("a") or dPadLeft() and player.isDead == false then
    player.isProne = false
    player.dx = -player.speed * dt
    player.lastDir = 0

    if love.keyboard.isDown("w") then -- UpLeft
      player.shootPoint.x, player.shootPoint.y = player.x - 50, player.y - 50
      player.controls[2].x, player.controls[2].y = -6, 0
      player.controls[3] = true
    elseif love.keyboard.isDown("s") then -- DownLeft
      player.shootPoint.x, player.shootPoint.y = player.x - 50, player.y + 50
      player.controls[2].x, player.controls[2].y = -7, 17
      player.controls[3] = true
    else                                  -- Left
      player.shootPoint.x, player.shootPoint.y = player.x - 50, player.y
      player.controls[2].x, player.controls[2].y = -10, 9
      player.controls[3] = true
    end

  elseif love.keyboard.isDown("w") then -- Up
    player.isProne = false
    player.shootPoint.x, player.shootPoint.y = player.x, player.y - 50
    player.controls[3] = true
    if player.lastDir == 1 then
      player.controls[2].x, player.controls[2].y = 2, -16
    else
      player.controls[2].x, player.controls[2].y = 4, -16
    end

  elseif love.keyboard.isDown("s") then -- Down
    if player.isJumping or player.isGrounded == false then
      player.isProne = false
      player.controls[3] = true
      player.shootPoint.x, player.shootPoint.y = player.x, player.y + 50
      player.controls[2].x, player.controls[2].y = 5, 30
    else
      if player.lastDir == 1 then    -- right
        player.shootPoint.x, player.shootPoint.y = player.x + 50, player.y
        player.controls[2].x, player.controls[2].y = 40, 41 -- 20 12
      elseif player.lastDir == 0 then -- left
        player.shootPoint.x, player.shootPoint.y = player.x - 50, player.y
        player.controls[2].x, player.controls[2].y = -34, 40
      end

      player.isProne = true
      player.controls[3] = true
    end

  else -- else player isn't hitting any of these keys so default them back to left/right
    player.isProne = false

    if player.lastDir == 1 then
      player.shootPoint.x, player.shootPoint.y = player.x + 50, player.y
      player.controls[2].x, player.controls[2].y = 21, 9 -- Static right
      player.controls[3] = true
    else
      player.shootPoint.x, player.shootPoint.y = player.x - 50, player.y
      player.controls[2].x, player.controls[2].y = -10, 9 -- Static left
      player.controls[3] = true
    end
  end

  if player.isProne then
    if player.lastDir == 1 then
      deviation = love.math.random(-1, -2) * 0.03
    else
      deviation = love.math.random(1, 2) * 0.03
    end
  else
    deviation = love.math.random(-1, 1) * 0.03
  end

  player.controls[1] = math.atan2(player.shootPoint.y - player.y, player.shootPoint.x - player.x) + deviation

  -- deceleration
  if (dPadRight() == false or love.keyboard.isDown("d") == false) and player.dx > 0 then -- moving right
    player.dx = math.max((player.dx - decel * dt), 0)
  elseif (dPadLeft() == false or love.keyboard.isDown("a") == false) and player.dx < 0 then -- moving left
    player.dx = math.min((player.dx + decel * dt), 0)
  end

  -- jump --
  if (love.keyboard.isDown('n') and player.isJumping == false and player.isGrounded and player.jumpLock == false) or (pressX() and player.isJumping == false and player.isGrounded) then -- when the player hits jump
    player.isJumping = true
    player.jumpLock = true
    player.isGrounded = false
    player.dy = -player.initVel -- 6 is our current initial velocity
    jumpTimer = jumpTimerMax
  elseif (love.keyboard.isDown('n') and jumpTimer > 0 and player.isJumping) or (pressX() and jumpTimer > 0 and player.isJumping) then
    player.dy = player.dy + (-0.5)
  elseif (love.keyboard.isDown('n') == false and player.isJumping) or (pressX() == false and player.isJumping) then -- if the player releases the jump button mid-jump...
    if player.dy < player.termVel then -- and if the player's velocity has reached the minimum velocity (minimum jump height)...
      player.dy = player.termVel -- terminate the jump
    end
    player.isJumping = false
  end

end

function updatePlayer(dt, world) -- Update Player Movement [http://2dengine.com/doc/gs_platformers.html] --
  --------- DEATH/LIFE/DEATH ---------

  if player.y + player.h > 220 then player.killPlayer() end -- if player falls down a pit, kill him

  if player.isDead then
    respawnTimer = respawnTimer - (1 * dt) -- decrement respawnTimer

    if player.isGrounded and player.isDead then
      player.curAnim = 10
      player.dx = 0
    end

    if respawnTimer <= 0 then
      -- revive player
      player.isDead = false
      player.curAnim = 1

      player.animations[8]:gotoFrame(1)
      player.animations[8]:resume()

      -- start invincibility timer
      invinceTimer = invinceTimerMax
      if player.lives == 0 then
        player.lives = -1
        player.type = "dead"
      end
    end
  end

  --------- RECTS AND TYPES ---------
  proneRect.x, proneRect.y = player.x + proneRect.offX, player.y + proneRect.offY

  -- decrement invincibility timer
  if invinceTimer > 0 then invinceTimer = invinceTimer - (1 * dt) end
  if respawnTimer <= 0 and invinceTimer <= 0 and player.type == "invincible" then player.type = "player" end

  if player.isProne and world:hasItem(proneRect) == false and player.isDead == false then
    player.type = "invincibleProne"
    world:add(proneRect, proneRect.x, proneRect.y, proneRect.w, proneRect.h)
  elseif player.isProne == false and world:hasItem(proneRect) == true then
    world:remove(proneRect)
    if player.isDead == false then
      player.type = "player"
    end
  end

  --------- MOVEMENT ---------
  if player.isDead == false then playerInput(dt, world) end

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
  if player.isGrounded == false then
    player.dy = player.dy + (gravity * dt)
  end

  if player.dx ~= 0 and player.lives > -1 or player.dy ~= 0 and player.lives > -1 then
    -- check if player has temporary invincibility
    if player.type == "invincible" then player.x, player.y, cols, len = world:move(player, player.x + player.dx, player.y + player.dy, player.respawnFilter)
    else player.x, player.y, cols, len = world:move(player, player.x + player.dx, player.y + player.dy, player.filter) end

    -- check if player is grounded
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

  --------- SHOOTING ---------

  -- decrement shootTimer and animTimer--
  if shootTimer > 0 then shootTimer = shootTimer - (1 * dt) end

  if animTimer > 0 then animTimer = animTimer - (1 * dt) end

  if (pressCircle() or love.keyboard.isDown('m')) and shootTimer <= 0 and player.shootLock == false and player.isDead == false and player.lives > -1 then
    if addBullet(false, player.x + player.controls[2].x, player.y + player.controls[2].y, player.lastDir, world, player.controls[1], player.isProne) then
      love.audio.play(playerSounds.shoot)
      player.shootLock = true

      if player.isProne then
        resetTimer(0.05, "proneShot", player.timers)
      end
    end

    shootTimer = shootTimerMax
    animTimer = animTimerMax
  end

  --------- ANIMATIONS ---------
  -- flip animations based on player's direction --
  if player.lastDir ~= player.prevDir then
    for i=1, table.getn(player.animations) do
      player.animations[i]:flipH()
    end
    player.prevDir = player.lastDir
  end

  -- set the player's current animation based on their movement
  if player.isDead == false then
    if player.isJumping or not player.isGrounded then
      player.curAnim = 6 -- [JUMPING]
    elseif player.dx <= 0.8 and player.dx >= -0.8 and love.keyboard.isDown('s') then
      if updateTimer(dt, "proneShot", player.timers) == false then
        player.curAnim = 12 -- [PRONE SHOOTING]
      else
        player.curAnim = 11 -- [PRONE]
      end
    elseif player.dx <= 0.8 and player.dx >= -0.8 and love.keyboard.isDown('w') == false
      then player.curAnim = 1 -- [IDLE]
    elseif player.dx <= 0.8 and player.dx >= -0.8 and love.keyboard.isDown('w')
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
  end

  -- update the player's current animation --
  player.animations[player.curAnim]:update(dt)
end

function drawPlayer()
  -- love.graphics.rectangle("line", player.x, player.y, player.w, player.h) -- player
  -- love.graphics.rectangle("line", proneRect.x, proneRect.y, proneRect.w, proneRect.h) -- prone
  if player.lives > -1 then
    if player.type == "player" or player.isDead or player.type == "invincibleProne" then
      setColor({255, 255, 255, 255})
      if player.curAnim < 10 then
        player.animations[player.curAnim]:draw(player.spriteSheet, player.x, player.y, 0, 1, 1, 11, 15) -- SCALED UP 2.5, 11 and 18.5 are offsets
      else
        player.animations[player.curAnim]:draw(player.spriteSheetHorizontal, player.x, player.y, 0, 1, 1, 30, -15) -- SCALED UP 2.5, 11 and 18.5 are offsets
      end
    elseif player.type == "invincible" then -- if the player just respawned, apply transparency
      setColor({255, 255, 255, 100})
      if player.curAnim < 10 then
        player.animations[player.curAnim]:draw(player.spriteSheet, player.x, player.y, 0, 1, 1, 11, 15) -- SCALED UP 2.5, 11 and 18.5 are offsets
      else
        player.animations[player.curAnim]:draw(player.spriteSheetHorizontal, player.x, player.y, 0, 1, 1, 30, -15) -- SCALED UP 2.5, 11 and 18.5 are offsets
      end
      setColor({255, 255, 255, 255})
    end
  end
end

return player
