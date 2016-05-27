-- game.lua --

-- Includes: --

anim8 = require 'other/anim8' -- this should be local in the future
local sti = require "sti"

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

require 'bosses/waterWalker'

local world = bump.newWorld() -- create a world with bump

game = {}

-- Globals: --
local debug = true
bossFight = false

--windowWidth, windowHeight = 800, 600

--windowWidth, windowHeight, windowScale = 320, 180, 1 -- 1:1
windowWidth, windowHeight, windowScale = 640, 360, 2 -- 2:2
--windowWidth, windowHeight, windowScale = 960, 540, 3 -- 3:3
--windowWidth, windowHeight, windowScale = 1280, 720, 4 -- 4:4
--windowWidth, windowHeight, windowScale = 1600, 900, 5  -- 5:5
--windowWidth, windowHeight, windowScale = 1920, 1080, 6 -- 6:6

-- Camera boundaries
local bounds = {
  levelWidth   = 5000,
  levelHeight  = windowHeight, -- windowHeight at minimum
  left = 0,
  top = 0,
  viewportWidth = 0,
  viewportHeight = 0,
}

-- game:enter(previous state, parameter being passed)
function game:enter(menu, levelName)
  -- seed math.random
  math.randomseed(os.time())
  love.graphics.setDefaultFilter( "nearest", "nearest") -- set nearest pixel distance

  -- load level
  loadLevel(levelName, world)

  -- load tilemap
  map = sti.new("tiled/Level 1-1.lua", {"bump"})
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
  loadPlayer(world) -- load player and player sprites

  -- load boss
  waterWalker:load(world)

  -- load camera
  camera.setBoundary(0, 0, bounds.levelWidth, windowHeight) -- load camera
  camera.setViewport(0, 0, 320, 180)
end


function game:update(dt)
  -- if player wants to quit
  if love.keyboard.isDown('escape') then love.event.quit() end -- if player hits esc then quit

  -- update bounds
  bounds.left, bounds.top, bounds.viewportWidth, bounds.viewportHeight = camera.getViewport()

  -- update everything
  updatePlayer(dt, world)
  updateBullets(dt, bounds.left, bounds.viewportWidth, world)

  updateEnemies(dt, world)
  updateZones(player.x, player.w, bounds.left, world, dt)

  if bossFight then -- if player activated boss fight, update boss
    waterWalker:update(dt, world)
  end

  -- update camera
  if checkScreenMove(bounds.left) and player.lastDir == 1 then -- if player is moving right and beyond the middle of the screen...
    camera.lookAt(player.x + player.w / 2, 0) -- set the camera to follow the player's movement
  end
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
  camera.draw(function(l,t,w,h)
    map:draw()
    drawPlayer()
    drawEnemies()
    drawBullets()
    drawBlocks()

    if bossFight then -- if player activated boss fight, update boss
      waterWalker:draw()
    end

    if debug then
      drawZones()
    end

  end)

  if bossFight then
    waterWalker:drawHealth()
  end
  --drawEnvironment()

  if debug then
    love.graphics.print(tostring(love.timer.getFPS( )), 5, 5) -- print fps in the top left corner of the screen
    love.graphics.printf(math.floor(player.x + 0.5), 5, 20, 100)
    love.graphics.print(player.lives, 5, 35)
    -- love.graphics.print(level.name, 700, 5)
    if player.lives == 0 then love.graphics.printf("GAME OVER", 360, 300, 100) end
  end
end
