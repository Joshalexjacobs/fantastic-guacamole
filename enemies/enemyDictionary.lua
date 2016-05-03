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
  -- static

  entity.animations[entity.curAnim]:update(dt)
end

local dictionary = {
  {
    name = "runner",
    hp = 1,
    w = 36,
    h = 72,
    update = runBehaviour,
    scale = {x = 2.5, y = 2.5, offX = 11, offY = 18.5},
    sprite = "img/enemies/runner.png",
    grid = {x = 34, y = 48, w = 102, h = 96},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid('1-3', '1-2'), 0.1) -- running
      }
      return animations
    end,
    filter = nil,
    gravity = 9.8
  },

  {
    name = "target",
    hp = 3,
    w = 32,
    h = 32,
    update = targetBehaviour,
    scale = {x = 1, y = 1, offX = 0, offY = 0},
    sprite = "img/enemies/target/target.png",
    grid = {x = 32, y = 32, w = 128, h = 64},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(1, 1), 0.1), -- intact - 1
        anim8.newAnimation(grid(2, 1), 0.1), -- outer layer hit - 2
        anim8.newAnimation(grid(3, 1), 0.1), -- inner layer hit - 3
        anim8.newAnimation(grid('3-4', 1, '1-2', 1), 0.8)  -- respawning - 4
      }
      return animations
    end,
    filter = nil,
    gravity = 0
  }
}

function getEnemy(newEnemy) -- create some sort of clever dictionary look up function later on..if A > B etc... dictionary stuff
  for i=1, #dictionary do

    if newEnemy.name == dictionary[i].name then
      newEnemy.hp, newEnemy.w, newEnemy.h = dictionary[i].hp, dictionary[i].w, dictionary[i].h
      newEnemy.behaviour = dictionary[i].update
      newEnemy.scale = dictionary[i].scale

      -- animation stuff
      newEnemy.spriteSheet = love.graphics.newImage(dictionary[i].sprite)
      newEnemy.spriteGrid = anim8.newGrid(dictionary[i].grid.x, dictionary[i].grid.y, dictionary[i].grid.w, dictionary[i].grid.h, 0, 0, 0)
      newEnemy.animations = dictionary[i].animations(newEnemy.spriteGrid)
      newEnemy.gravity = dictionary[i].gravity
    end
  end
end
