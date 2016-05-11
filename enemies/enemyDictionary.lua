-- enemyDictionary.lua --

-- enemy functions

-- RUNNER --
local function runBehaviour(dt, entity)
    if entity.direction == "right" then
      entity.dx = entity.speed * dt
    elseif entity.direction == "left" then
      entity.dx = -(entity.speed * dt)
    end

    if entity.isDead then entity.playDead = true end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

-- TARGET --
local function targetBehaviour(dt, entity)
  -- static

  if entity.isDead then
    -- create a timer.. etc
    entity.curAnim = 2
    addTimer(0.3, "death", entity.timers)
    if updateTimer(dt, "death", entity.timers) then
      entity.playDead = true
    end
  end

  entity.animations[entity.curAnim]:update(dt)
end

-- SHOOTER-RUNNER --
local function srBehaviour(dt, entity)
    -- set timers (do this ONCE) --
    if not checkTimer("shoot", entity.timers) then
      addTimer(0.0, "shoot", entity.timers)
      print("create shoot timer for the first time")
    end

    -- set direction
    if player.x > entity.x and entity.direction ~= "right" then
      entity.direction = "right"

      for i = 1, #entity.animations do
        entity.animations[i]:flipH()
      end

    elseif player.x < entity.x and entity.direction ~= "left" then
      entity.direction = "left"

      for i = 1, #entity.animations do
        entity.animations[i]:flipH()
      end

    end

    -- movement/shooting
    if math.abs(entity.x - player.x) > 200 and updateTimer(dt, "shoot", entity.timers) then
      entity.curAnim = 1
      if entity.direction == "right" then
        entity.dx = entity.speed * dt
      elseif entity.direction == "left" then
        entity.dx = -(entity.speed * dt)
      end
    else
      entity.dx = 0
      entity.curAnim = 2

      if updateTimer(dt, "shoot", entity.timers) then
        resetTimer(1.2, "shoot", entity.timers) -- add timer
      end
    end

    if entity.isDead then entity.playDead = true end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)

    print(entity.dy)
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
    name = "shooter/run",
    hp = 1,
    w = 36,
    h = 72,
    update = srBehaviour,
    scale = {x = 2.5, y = 2.5, offX = 11, offY = 18.5},
    sprite = "img/enemies/shooter-run/shooter-run.png",
    grid = {x = 34, y = 48, w = 102, h = 144}, -- 27, 35,
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid('1-3', '1-2'), 0.1), -- running
        anim8.newAnimation(grid(1, 3), 0.1), -- shooting/stopped
        anim8.newAnimation(grid(2, 2), 0.1) -- falling
      }
      return animations
    end,
    filter = nil,
    gravity = 9.8
  },

  {
    name = "target",
    hp = 1,
    w = 56,
    h = 56,
    update = targetBehaviour,
    scale = {x = 2, y = 2, offX = 2, offY = 2},
    sprite = "img/enemies/target/target.png",
    grid = {x = 32, y = 32, w = 96, h = 32},
    animations = function(grid)
      animations = {
        anim8.newAnimation(grid(1, 1), 0.1),     -- idle - 1
        anim8.newAnimation(grid('2-3', 1), 0.15), -- hit  - 2
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
