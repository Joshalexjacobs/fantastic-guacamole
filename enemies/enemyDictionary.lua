-- enemyDictionary.lua --

-- enemy functions

-- RUNNER --
local function runBehaviour(dt, entity)
    if entity.direction == "right" then
      entity.dx = entity.speed * dt
    elseif entity.direction == "left" then
      entity.dx = -(entity.speed * dt)
    end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

-- TARGET --
local function targetBehaviour(dt, entity)
  -- static, if hit destroyed...start timer and then respawn
end

local dictionary = {
  {
    name = "runner",
    update = runBehaviour,
    sprite = "img/enemies/runner.png",
    grid = {x = 34, y = 48, w = 102, h = 96},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid('1-3', '1-2'), 0.1) -- running
      }
      return animations
    end,
    filter = nil
  },

  {
    name = "target",
    update = runBehaviour,
    sprite = "img/enemies/target/target.png",
    grid = {x = 32, y = 32, w = 128, h = 64},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(1, 1), 0.1), -- intact
        anim8.newAnimation(grid(2, 1), 0.1), -- outer layer hit
        anim8.newAnimation(grid(3, 1), 0.1), -- inner layer hit
        anim8.newAnimation(grid('3-4', 1, '1-2', 1), 0.1)  -- respawning
      }
      return animations
    end,
    filter = nil
  }
}

function getEnemy(newEnemy) -- create some sort of clever dictionary look up function later on..if A > B etc... dictionary stuff
  for i=1, #dictionary do

    if newEnemy.name == dictionary[i].name then
      newEnemy.behaviour = dictionary[i].update

      -- animation stuff
      newEnemy.spriteSheet = love.graphics.newImage(dictionary[i].sprite)
      newEnemy.spriteGrid = anim8.newGrid(dictionary[i].grid.x, dictionary[i].grid.y, dictionary[i].grid.w, dictionary[i].grid.h, 0, 0, 0)
      newEnemy.animations = dictionary[i].animations(newEnemy.spriteGrid)
    end
  end
end
