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
endLevel = false

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

local gui = {
  livesX = 5,
  livesY = 5,
  livesPadding = 18, -- 15
  livesSprite = "img/other/lives.png",
  livesSpriteSheet = nil,
  livesGrid = nil,
  livesAnimations = nil,
  livesCurAnim = 1,
}

local leftWall = {
  name = "leftWall",
  type = "pBlock",
  filter = function(item, other)
    if other.type == "player" then
      return 'slide'
    end
  end,
  x = 0,
  y = 0,
  h = 200,
  w = 10
}

local fade = {
  x = 0,
  y = 0,
  w = 320,
  h = 180,
  speed = 180,
  transparency = 255,
  volume = 0,
  fadeIn = function(dt, fade, music)
    if fade.transparency > 0 then
      fade.transparency = fade.transparency - fade.speed * dt
    end

    if fade.volume < 0.75 then
      fade.volume = fade.volume + 0.1 * dt
      music:setVolume(fade.volume)
    end
  end,
  fadeOut = function(dt, fade, music)
    if fade.transparency < 255 then
      fade.transparency = fade.transparency + fade.speed * dt
    end

    if fade.volume > 0 then
      fade.volume = fade.volume - 0.5 * dt
      music:setVolume(fade.volume)
    end
  end,
  draw = function(fade)
    setColor(0, 0, 0, fade.transparency)
    love.graphics.rectangle("fill", fade.x, fade.y, fade.w, fade.h)
    setColor(255, 255, 255, 255)
  end
}

-- Level specific functions
local levelFunctions = {}

function game:enter(menu, levelName, res)
  windowWidth, windowHeight, windowScale = res.w, res.h, res.s

  tutMusic = love.audio.newSource("music/matrix.wav", stream)

  -- adjust window
  love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})

  -- seed math.random
  math.randomseed(os.time())
  love.graphics.setDefaultFilter( "nearest", "nearest") -- set nearest pixel distance

  -- load level
  local pSkinV, pSkinH, tilemap, startPos = loadLevel(levelName, world, levelFunctions)

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

  world:add(leftWall, leftWall.x, leftWall.y, leftWall.w, leftWall.h)

  -- set level bounds
  bounds = level.bounds

  -- adjust window
  --love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})

  -- load player
  player.x = startPos -- set player starting position
  loadPlayer(world, pSkinV, pSkinH) -- load player and player sprites

  -- run level specific load
  if levelFunctions.load ~= nil then levelFunctions.load() end

  -- load gui
  gui.livesSpriteSheet = love.graphics.newImage(gui.livesSprite)
  gui.livesGrid = anim8.newGrid(16, 16, 32, 16, 0, 0, 0)
  gui.livesAnimations = {
    anim8.newAnimation(gui.livesGrid(1, 1), 0.1), -- 1 regular lives
    anim8.newAnimation(gui.livesGrid(2, 1), 0.1), -- 2 tutorial lives
  }

  if level.name == "tutorial" then gui.livesCurAnim = 2 end

  -- load boss
  waterWalker:load(world)

  -- load camera
  camera = Camera(player.x + 20 + (160 * (windowScale - 1)), 90 * windowScale, 1, 0, Camera.smooth.linear(100))
  camera.smoother = Camera.smooth.forwardDamped(3)
end


function game:update(dt)
  if tutMusic:isPlaying() == false then
    love.audio.play(tutMusic)
  end


  if endLevel == false then
    fade.fadeIn(dt, fade, tutMusic)
  elseif endLevel then
    fade.fadeOut(dt, fade, tutMusic)
  end

  dt = math.min(dt, 1/maxFPS)

  -- if player wants to quit
  if love.keyboard.isDown('escape') then love.event.quit() end -- if player hits esc then quit

  -- update bounds
  local left, right = camera:position()
  bounds.left = left - ((180 * windowScale) - (20 * windowScale))

  leftWall.x = bounds.left
  world:move(leftWall, leftWall.x, leftWall.y, leftWall.filter)

  -- run level specific update
  if levelFunctions.update ~= nil then levelFunctions.update(dt) end

  -- update everything
  updatePlayer(dt, world)

  updateBullets(dt, bounds.left, 320, world)
  updateBubbles(dt, world)

  updateEnemies(dt, world)
  updateZones(player.x, player.w, bounds.left, world, dt)

  if bossFight then -- if player activated boss fight, update boss
    waterWalker:update(dt, world)
  end

  -- update gui
  gui.livesAnimations[gui.livesCurAnim]:update(dt)

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

    -- run level specific draw
    if levelFunctions.draw ~= nil then levelFunctions.draw() end

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

    -- draw leftWall
    -- love.graphics.rectangle("line", leftWall.x, leftWall.y, leftWall.w, leftWall.h)

  camera:detach()

  -- draw gui
  setColor({255, 255, 255, 180}) -- set transparency

  for i = 0, player.lives - 1 do
    if i > 2 then break end
    gui.livesAnimations[gui.livesCurAnim]:draw(gui.livesSpriteSheet, gui.livesX + gui.livesPadding * i, gui.livesY, 0, 1, 1, 0, 0)
  end

  setColor({255, 255, 255, 255})

  if bossFight then
    waterWalker:drawHealth()
  end

  if debug then
    love.graphics.print(tostring(love.timer.getFPS( )), 0.2, 0.2, 0, 0.35, 0.35) -- print fps in the top left corner of the screen
    --love.graphics.printf(math.floor(player.x + 0.5), 5, 20, 100)
    --love.graphics.print(player.lives, 5, 35)
    if player.lives == 0 then love.graphics.printf("GAME OVER", 360, 300, 100) end
  end

  -- draw fade
  fade.draw(fade)

end
