-- enemyDictionary.lua --

-- enemy functions
function runBehaviour(dt, entity)
    if entity.direction == "right" then
      entity.dx = entity.speed * dt
    elseif entity.direction == "left" then
      entity.dx = -(entity.speed * dt)
    end

    -- handle/update current animation running
    entity.animations[entity.curAnim]:update(dt)
end

local dictionary = {
  {
    name = "runner",
    update = runBehaviour,
    sprite = "img/enemies/runner.png",
    grid = {x = 34, y = 48, w = 102, h = 96},
    animations = nil,
    filter = nil
  }
}

function getEnemy(newEnemy) -- create some sort of clever dictionary look up function later on
  if newEnemy.name == dictionary[1].name then
    newEnemy.behaviour = dictionary[1].update

    -- animation stuff
    newEnemy.spriteSheet = love.graphics.newImage(dictionary[1].sprite)
    newEnemy.spriteGrid = anim8.newGrid(dictionary[1].grid.x, dictionary[1].grid.y, dictionary[1].grid.w, dictionary[1].grid.h, 0, 0, 0)
    newEnemy.animations = {
      anim8.newAnimation(newEnemy.spriteGrid('1-3', '1-2'), 0.1)
    }
  end
end
