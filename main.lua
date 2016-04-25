--[[
-- Todo: --
1. Basic obstacles and obstructions that the player has to jump over
2. Force the player to tap the shoot button instead of just holding it down
3. Read this https://www.reddit.com/r/gamedev/comments/25tk7d/finally_finished_my_multipart_technical_series/
4. And these https://www.reddit.com/r/gamedev/comments/1f83c5/3_articles_about_component_entity_systems/
5. Implement game states (menu, pause, game over, etc...) [love2d library known as HUMP]
6. Decrease enemy/player hit boxes by a few pixels (5 or so)
7. Add parallax http://nova-fusion.com/2011/04/22/cameras-in-love2d-part-2-parallax-scrolling/
8. Make the bullets bigger with muzzle flash
9. Add screenshake (watch the art of screenshake)
10. Decrease the size of the player's hit box only while jumping
-- Things to Note: --
1. Every item that is added to world MUST have a string called 'name'.
2. Every object in world must also have a filter or else it may react unexpectedly.
3. Bullets currently handle setting enemies.isDead to true because updateBullets is called before updateEnemies.

-- Credits: --
-- Kikito for the bump and anim8 libraries.
-- Whoever made the camera library I'm using (should figure this out)
-- Ethan Smoller for introducing me to Love2d.
-- whoever made hump? kikito?
--]]

-- Includes: --
require 'collision/blocks'
require 'enemies/enemyDictionary'
require 'other/environment'
require 'other/controller'

require 'levels/levelsDictionary'
require 'cflux'
require 'bullets'

Gamestate = require 'gamestates/gamestate'
require 'gamestates/start'
require 'gamestates/game'

local math   = require "math"
local camera = require "camera"
local player = require 'player'
require 'enemies/enemies'
local bump   = require 'collision/bump'
anim8 = require 'other/anim8' -- this should be local in the fututre

require 'levels/zones'
require 'levels/levels'

world = bump.newWorld() -- create a world with bump

function love.load(arg)
  Gamestate.registerEvents()
  Gamestate.switch(menu)
end
