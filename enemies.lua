-- enemies.lua --

require 'enemies/behaviours'

-- Ideas:
-- * Level bossess can be handled by a different file, enemies should be as general as possible
-- * For enemy behaviour read this : https://www.reddit.com/r/gamedev/comments/23oxp6/build_a_bad_guy_workshop_designing_enemies_for/

-- Idea 3:
-- Enemies will be stored in a table called "enemies".
-- Inside will be an enemy object which contains:
-- * Behaviour ID (determines what kind of behaviours each enemy has)
-- * Health
-- * Position
-- * Speed
-- * Velocity
-- * Direction
-- * Width/height

-- I'll need to create a way to create the hashcode for each enemy and then attach a behaviours.lua to this file which
-- will be full of functions regarding the enemies behaviours.

local enemy = {
  id = 0, -- i should figure out some sort of file i/o or database for this part... or just store them in a seperate lua file
  health = 0,
  x = 0,
  y = 0,
  w = 32,
  h = 64,
  speed = 0,
  dx = 0,
  dy = 0,
  direction = "",
  behaviours = {},
  color = {255, 0, 0, 255}
}

enemies = {}

-- function generateEnemies() -- randomly generates an enemy based on optional parameters

function addEnemy(ID)
  table.insert(enemies, enemy)
  --parseID(ID)
end

function updateEnemies()
  for i, enemy in ipairs(enemies) do
    -- enemy stuff here
  end
end

function drawEnemies()
  for i, enemy in ipairs(enemies) do
    setColor(enemy.color) -- set each bullet's color
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
  end
end

return enemies
