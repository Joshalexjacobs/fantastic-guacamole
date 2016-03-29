-- enemyDictionary.lua --

-- enemy functions
function runBehaviour(dt, entity)
    if entity.direction == "right" then
      entity.dx = entity.speed * dt
    elseif entity.direction == "left" then
      entity.dx = -(entity.speed * dt)
    end

    -- handle/update current animation running
end

local dictionary = {
  {
    name = "runner",
    update = runBehaviour,
    sprite = "img/enemies/runner.png",
    grid = nil,
    animations = {},
    filter = nil
  }
}

-- function getEnemy(newEnemy) -- create some sort of clever dictionary look up function later on
  -- if newEnemy.name == dictionary[1].name then
    -- newEnemy.behaviours = dictionary[1].update
    -- newEnemy.sprite = dictionary[1].sprite
    -- etc...
  -- end
-- end
