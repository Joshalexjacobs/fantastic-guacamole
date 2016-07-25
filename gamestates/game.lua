-- game.lua --

-- Includes: --

anim8 = require 'other/anim8' -- this should be local in the future
local sti = require "sti"

require 'enemies/enemyDictionary'
require 'enemies/enemies'

require 'other/controller'
require 'other/timer'

require 'levels/levelsDictionary'
require 'cflux'
require 'bullets'
require 'bubble'

local bump   = require 'collision/bump'
local math   = require "math"

local Camera = require "humpCamera"

player = require 'player'

require 'levels/zones'
require 'levels/levels'

require 'bosses/waterWalker'

local world = bump.newWorld() -- create a world with bump

game = {}

-- Globals: --
local debug = true
bossFight = false
maxFPS = 60

--windowWidth, windowHeight, windowScale = 320, 180, 1 -- 1:1
--windowWidth, windowHeight, windowScale = 640, 360, 2 -- 2:2
windowWidth, windowHeight, windowScale = 960, 540, 3 -- 3:3
--windowWidth, windowHeight, windowScale = 1280, 720, 4 -- 4:4
--windowWidth, windowHeight, windowScale = 1600, 900, 5  -- 5:5
--windowWidth, windowHeight, windowScale = 1920, 1080, 6 -- 6:6

-- Camera boundaries
local bounds = {
  levelWidth   = 5000,
  levelHeight  = windowHeight, -- windowHeight at minimum
  left = 0,
  top = 0
}

function game:enter(menu, levelName)
  -- seed math.random
  math.randomseed(os.time())
  love.graphics.setDefaultFilter( "nearest", "nearest") -- set nearest pixel distance

  -- load level
  local pSkinV, pSkinH, tilemap, startPos = loadLevel(levelName, world)

  -- load bullet and bubble
  loadBullet()
  loadBubbles()

  -- load tilemap
  map = sti.new(tilemap, {"bump"})

  map:bump_init(world)

  -- populate world collision (bump)
  for _, object in ipairs(map.objects) do
    if object.properties.collidable then
      world:add(object, object.x, object.y, object.width, object.height)
    end
  end

  -- set level bounds
  bounds = level.bounds

  -- adjust window
  love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})

  -- load player
  player.x = startPos -- set player starting position
  loadPlayer(world, pSkinV, pSkinH) -- load player and player sprites


  -- load boss
  waterWalker:load(world)

  -- load camera
  camera = Camera(player.x + 20 + (160 * (windowScale - 1)), 90 * windowScale, 1, 0, Camera.smooth.linear(100))
  camera.smoother = Camera.smooth.forwardDamped(3)
end


function game:update(dt)
  dt = math.min(dt, 1/maxFPS)

  -- if player wants to quit
  if love.keyboard.isDown('escape') then love.event.quit() end -- if player hits esc then quit

  -- update bounds
  local left, right = camera:position()
  bounds.left = left - ((180 * windowScale) - (20 * windowScale))

  -- update everything
  updatePlayer(dt, world)

  updateBullets(dt, bounds.left, 320, world)
  updateBubbles(dt, world)

  updateEnemies(dt, world)
  updateZones(player.x, player.w, bounds.left, world, dt)

  if bossFight then -- if player activated boss fight, update boss
    waterWalker:update(dt, world)
  end

  camera:lockPosition(player.x + 20 + (160 * (windowScale - 1)), 90 * windowScale)
end

function game:keyreleased(key, code)
  if key == 'n' then
    player.jumpLock = false
  elseif key == 'm' then
    player.shootLock = false
  end
end

function game:draw()

  love.graphics.scale(windowScale, windowScale)

  camera:attach()
    map:draw()
    drawPlayer()
    drawEnemies()
    drawBullets()
    drawBubbles()

    if bossFight then -- if player activated boss fight, update boss
      waterWalker:draw()
    end

    if debug then
      --drawZones()
    end

  camera:detach()

  if bossFight then
    waterWalker:drawHealth()
  end

  if debug then
    love.graphics.print(tostring(love.timer.getFPS( )), 5, 5) -- print fps in the top left corner of the screen
    love.graphics.printf(math.floor(player.x + 0.5), 5, 20, 100)
    love.graphics.print(player.lives, 5, 35)
    if player.lives == 0 then love.graphics.printf("GAME OVER", 360, 300, 100) end
  end
end
