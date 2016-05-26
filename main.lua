--[[
-- Todo: --
1. Basic obstacles and obstructions that the player has to jump over
3. Read this https://www.reddit.com/r/gamedev/comments/25tk7d/finally_finished_my_multipart_technical_series/
4. And these https://www.reddit.com/r/gamedev/comments/1f83c5/3_articles_about_component_entity_systems/
5. Implement game states (menu, pause, game over, etc...) [love2d library known as HUMP]
7. Add parallax http://nova-fusion.com/2011/04/22/cameras-in-love2d-part-2-parallax-scrolling/
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
-- guy who made sti
--]]

-- Gamestates --
Gamestate = require 'gamestates/gamestate'
require 'gamestates/start'
require 'gamestates/game'

-- Global Functions --
function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function love.load(arg)
  -- load font
  smallFont = love.graphics.newFont("img/fonts/OpenSansPXBold.ttf", 17)
  teenyFont = love.graphics.newFont("img/fonts/OpenSansPXBold.ttf", 13)
  love.graphics.setFont(smallFont)

  Gamestate.registerEvents()
  Gamestate.switch(menu)
end
