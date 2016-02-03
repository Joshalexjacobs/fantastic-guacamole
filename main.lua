--[[
-- Todo: --
  Current Issues:
  - Some player movement choppiness, this might be due to the camera movement itself
1. Implement enemies somehow, possible an entity.lua that adds behaviour to objects/enemies?
2. Basic obstacles and obstructions that the player has to jump over
3. Force the player to tap the shoot button instead of just holding it down
4. Change player.lastDir system
5. Read this https://www.reddit.com/r/gamedev/comments/25tk7d/finally_finished_my_multipart_technical_series/
6. And these https://www.reddit.com/r/gamedev/comments/1f83c5/3_articles_about_component_entity_systems/
7. Implement game states (menu, pause, game over, etc...)
--]]

-- Includes: --
require 'collision/blocks'
require 'cflux'
require 'bullets'
require 'other/controller'
local math   = require "math"
local camera = require "camera"
local player = require 'player'
local enemies = require 'enemies'
local bump   = require 'collision/bump'

-- Globals: --
local debug = true

windowWidth, windowHeight = 800, 600

-- Camera boundaries
local bounds = {
  width   = 5000,
  height  = windowHeight,
  left    = 0,
  top     = 0,
  rows    = 2,
  columns = 20
}

local world = bump.newWorld() -- create a world with bump

function love.load(arg)
  -- collision
  addBlock(0, love.graphics.getHeight() - 25, bounds.width, 160, world) -- floor

  -- other
  loadController()
  love.window.setMode( windowWidth, windowHeight, {fullscreen=false, vsync=true})
  --love.mouse.setVisible(false)

  loadPlayer(world)
  camera.setBoundary(0, 0, bounds.width, bounds.height) -- load camera

  -- test functions:
  --addEnemy("azzzz")
  addEnemy({'a','z','z','z','z'})
end

function love.update(dt)
  -- if player wants to quit
  if love.keyboard.isDown('escape') then love.event.quit() end -- if player hits esc then quit

  -- update bounds
  bounds.left, bounds.top = camera.getViewport()

  -- update everything
  updateCFlux()
  updatePlayer(dt, world)
  updateBullets(dt, bounds.left)

end

-- will be removing this at a later time
local function drawGrid()
  local columnWidth = bounds.width / bounds.columns
  for x=1, bounds.columns do
    love.graphics.line(x*columnWidth, 0, x*columnWidth, bounds.height)
  end
  local rowHeight = bounds.height / bounds.rows
  for y=1, bounds.rows do
    love.graphics.line(0, y*rowHeight, bounds.width, y*rowHeight)
  end
end

function love.draw()

  -- update camera
  if checkScreenMove(bounds.left) and player.lastDir == 1 then -- if player is moving right and beyond the middle of the screen...
    camera.lookAt(player.x + player.w / 2, 0) -- set the camera to follow the player's movement
  end

  camera.draw(function(l,t,w,h)
    -- color independent draws
    drawPlayer()
    drawBullets()
    drawEnemies()

    -- draws that are determined by cflux
    setCFluxColor()
    drawBlocks()

    if debug then
      drawGrid()
    end
  end)

  if debug then
    love.graphics.print(tostring(love.timer.getFPS( )), 5, 5) -- print fps in the top left corner of the screen
  end
end
