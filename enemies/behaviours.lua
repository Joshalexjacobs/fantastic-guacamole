-- behaviours.lua --


function runBehaviour(dt, entity)
    if entity.direction == "right" then
      entity.dx = entity.speed * dt
    elseif entity.direction == "left" then
      entity.dx = -(entity.speed * dt)
    end

    -- return animation index
end

behaviourTable = {
  { -- movement 1
    {
      name = "run",
      update = runBehaviour -- to call behaviourTable[i][j].update
    },
    {
      name = "walk"
    },
    {
      name = "hover"
    },
    {
      name = "fly"
    },
    {
      name = "static"
    }
  },
  { -- movement 2
    {
      name = "jump"
    },
    {
      name = "rotate"
    },
    {
      name = "teleport"
    },
    {
      name = "rise"
    },
    {
      name = "spawn"
    },
    {
      name = "wallcrawl"
    }
  },
  { -- movement 3
    {
      name = "shoot"
    },
    {
      name = "grenade"
    },
    {
      name = "shootNGrenade" -- ???
    }
  }
}

function parseID(ID)
  result = {}

  for i=1, table.getn(behaviourTable) do
    if ID[i] == "" and i == table.getn(ID) then -- if the last element is empty...
      break
    end

    for j=1, table.getn(behaviourTable[i]) do
      if ID[i] == behaviourTable[i][j].name then
        table.insert(result, behaviourTable[i][j])
      end
    end

  end

  return result
end
