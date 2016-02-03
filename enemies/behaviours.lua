-- behaviours.lua

local function runBehaviour(a)
    print(a)
end

behaviourTable = {
  movement1 = {
    run = {
      'a',
      update = runBehaviour -- to call: behaviourTable.movement1.run.update('')
    },
    walk = 'b',
    hover = 'c',
    fly = 'd',
    static = 'e',
    none = 'z'
  },

  movement2 = {
    jump = 'a',
    rotate = 'b',
    teleport = 'c',
    rise = 'd',
    spawn = 'e',
    wallcrawl = 'f',
    none = 'z'
  },

  attack = {
    shoot = 'a',
    grenade = 'b',
    shootNGrenade = 'c',
    none = 'z'
  },

  other1 = {
    none = 'z'
  },

  other2 = {
    none = 'z'
  }
}

function parseID(ID) -- azzzz
  -- parse ID and add behaviours to the enemies.behaviours table
  for i=1, table.getn(ID) do
    print(ID[i])
    -- another loop? i really rather only do 1 other loop, not 2
  end
  -- for i=1,ID.size(),1 do
  --  another loop here?
  --
  --  if ID[i] ==
  --
  --end
end
