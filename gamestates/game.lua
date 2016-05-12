-- game.lua --

-- Includes: --

anim8 = require 'other/anim8' -- this should be local in the future

require 'collision/blocks'
require 'enemies/enemyDictionary'
require 'enemies/enemies'
require 'other/environment'
require 'other/controller'
require 'other/timer'

require 'levels/levelsDictionary'
require 'cflux'
require 'bullets'

local bump   = require 'collision/bump'
local math   = require "math"
local camera = require "camera"
player = require 'player'

require 'levels/zones'
require 'levels/levels'

local world = bump.newWorld() -- create a world with bump

game = {}

-- Globals: --
local debug = true

windowWidth, windowHeight = 800, 600

-- Camera boundaries
local bounds = {
  width   = 5000,
  height  = windowHeight,
  left    = 0,
  top     = 0
}

-- game:enter(previous state, parameter being passed)
function game:enter(menu, levelName)
  -- seed math.random
  math.randomseed(os.time())

  -- load level
  loadLevel(levelName, world)
  bounds = level.bounds

  -- other
  loadController()
  love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})

  loadPlayer(world) -- load player and player sprites
  camera.setBoundary(0, 0, bounds.width, bounds.height) -- load camera
end


function game:update(dt)
  -- if player wants to quit
  if love.keyboard.isDown('escape') then love.event.quit() end -- if player hits esc then quit

  -- update bounds
  bounds.left, bounds.top = camera.getViewport()

  -- update everything
  updateCFlux()
  updatePlayer(dt, world)
  updateBullets(dt, bounds.left, world)

  updateEnemies(dt, world)
  updateZones(player.x, player.y, player.w, bounds.left, world, dt)
end

function game:draw()

  -- update camera
  if checkScreenMove(bounds.left) and player.lastDir == 1 then -- if player is moving right and beyond the middle of the screen...
    camera.lookAt(player.x + player.w / 2, 0) -- set the camera to follow the player's movement
  end

  camera.draw(function(l,t,w,h)
    -- color independent draws
    drawPlayer()
    drawBullets()
    drawEnemies()

    if debug then
      --drawZones()
    end

    -- draws that are determined by cflux
    setCFluxColor()
    drawBlocks()
  end)

  drawEnvironment()

  if debug then
    love.graphics.print(tostring(love.timer.getFPS( )), 5, 5) -- print fps in the top left corner of the screen
    love.graphics.printf(math.floor(player.x + 0.5), 5, 20, 100)
    love.graphics.print(player.lives, 5, 35)
    love.graphics.printf(level.name, 700, 5, 100)
    if player.lives == 0 then love.graphics.printf("GAME OVER", 360, 300, 100) end
  end
end
