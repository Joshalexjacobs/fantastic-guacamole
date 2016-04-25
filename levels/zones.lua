-- zones.lua --

-- zones indicate enemy spawns/item drops/boss encounters/trigger events
-- all dependent on whether or not the player is inside of said zone (rectangle)

local defaultSpawn = {
  name = "default",
  count = 0,
  max = 3,
  side = "rand",
  spawnTimer = 0,
  spawnTimerMax = 0.7
}

local zone = {
  x = 0,
  y = 0,
  w = 0,
  h = 0,
  spawnables = {},
  color = {
    inner = {0, 250, 0, 20}, -- inner color
    outer = {0, 250, 0, 100} -- outer
  }
}

zones = {}

local function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function addZone(x, y, w, h, enemies)
  local newZone = copy(zone, newZone)
  newZone.x, newZone.y, newZone.w, newZone.h = x, y, w, h

  for i = 1, #enemies do -- add spawnable enemies to the zone
    local newSpawn = copy(defaultSpawn, newSpawn)
    newSpawn.name = enemies[i]
    table.insert(newZone.spawnables, newSpawn)
  end

  table.insert(zones, newZone)
end

function updateZones(x, y, w, left, world, dt)
  for _, newZone in ipairs(zones) do
    if x + w > newZone.x and x < newZone.x + newZone.w then

        for _, spawn in ipairs(newZone.spawnables) do
          if spawn.count < spawn.max and spawn.spawnTimer <= 0 then
            spawn.spawnTimer = spawn.spawnTimerMax

            if spawn.side == "rand" then
              if love.math.random(1, 2) == 1 then
                addEnemy(spawn.name, left - 32, 50, "right", world)
              else
                addEnemy(spawn.name, left + 832, 50, "left", world)
              end
            else
              addEnemy(spawn.name, left - 32, 50, spawn.side, world)
            end

            spawn.count = spawn.count + 1
          end

          if spawn.spawnTimer > 0 then
            spawn.spawnTimer = spawn.spawnTimer - (1 * dt)
          end
        end

      end -- elseif player leaves the zone, reset spawn count and timer
    end
  -- if the zone is no longer visible on the screen, then delete the zone?
end

function drawZones() -- zone's draw function should only be called when debug is true
  for _, newZone in ipairs(zones) do
    setColor(newZone.color.inner)
    love.graphics.rectangle("fill", newZone.x, newZone.y, newZone.w, newZone.h)
    setColor(newZone.color.outer)
    love.graphics.rectangle("line", newZone.x, newZone.y, newZone.w, newZone.h)
  end
end
