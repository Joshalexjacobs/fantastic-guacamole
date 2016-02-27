-- player.lua --

-- Player Class: --
local player = {
  name = "player",
  x = 375,
  y = 250,
  w = 32,
  h = 64,
  dx = 0,
  dy = 0,
  speed = 200,
  initVel = 6,
  termVel = -3,
  isJumping = false,
  isGrounded = false,
  isThrowing = false,
  lastDir = 1, -- temporary solution and how it works:
              -- if lastDir is equal to 1 the player is facing right
              -- if it is equal to 0 then the player is facing left
  spriteSheet = nil,
  spiteGrid = nil,
  animations = {},
  color = {255, 255, 255, 255}
}

local midpoint

function loadPlayer(world, anim8)
  world:add(player, player.x, player.y, player.w, player.h)
  midpoint = windowWidth / 2 -- calculate midpoint

  -- load player sprites
  player.spriteSheet = love.graphics.newImage('img/player/player.png')
  player.spriteGrid = anim8.newGrid(32, 64, 96, 448, 0, 0, 0)

  player.animations = {
    -- idlerun 1-6
    -- horizontalshotrun 7-12
    -- diagshotrun 13-18
    -- look up 19
    -- idle 20-21
  }
end

-- Player Globals: --
local shootTimerMax = 0.2
local shootTimer = 0

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

function updatePlayer(dt, world) -- Update Player Movement [http://2dengine.com/doc/gs_platformers.html] --
  -- MOVEMENT --
  -- player X movement --
  if love.keyboard.isDown('right') or dPadRight() then
    player.dx = player.speed * dt
    player.lastDir = 1
  elseif love.keyboard.isDown('left') or dPadLeft() then
    player.dx = -player.speed * dt
    player.lastDir = 0
  end

  -- deceleration --
  if (love.keyboard.isDown("right") == false or dPadRight() == false) and player.dx > 0 then
		player.dx = math.max((player.dx - decel * dt), 0)
	elseif (love.keyboard.isDown("left") == false or dPadLeft() == false) and player.dx < 0 then
		player.dx = math.min((player.dx + decel * dt), 0)
  end

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

  -- player jump --
  if (love.keyboard.isDown('space') and not player.isJumping and player.isGrounded) or (pressX() and not player.isJumping and player.isGrounded) then -- when the player hits jump
    player.isJumping = true
    player.isGrounded = false
    player.dy = -player.initVel -- 6 is our current initial velocity
    jumpTimer = jumpTimerMax
  elseif (love.keyboard.isDown('space') and jumpTimer > 0 and player.isJumping) or (pressX() and jumpTimer > 0 and player.isJumping) then
    player.dy = player.dy + (-0.5)
  elseif (not love.keyboard.isDown('space') and player.isJumping) or (not pressX() and player.isJumping) then -- if the player releases the jump button mid-jump...
    if player.dy < player.termVel then -- and if the player's velocity has reached the minimum velocity (minimum jump height)...
      player.dy = player.termVel -- terminate the jump
    end
    player.isJumping = false
  end

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
  -- decrement shootTimer --
  if shootTimer > 0 then
    shootTimer = shootTimer - (1 *  dt)
  end

  -- player shoot -- !!! this must be modified in the future to force the player to tap the circle/shoot button
  if (pressCircle() or love.keyboard.isDown('up')) and shootTimer <= 0 then
    addBullet(player.x, player.y + player.w, player.lastDir, world)
    shootTimer = shootTimerMax
  end

end

function checkScreenMove(left)
  if player.x + player.w / 2 > midpoint + left then
    return true
  else
    return false
  end
end

function drawPlayer()
  setColor(player.color) -- sets the player's color
  love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
  love.graphics.draw(player.spriteSheet, 0, 0, 0, 2, 2, 0, 0)
end

return player
