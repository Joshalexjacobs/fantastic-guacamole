-- zones.lua --

-- zones indicate enemy spawns/item drops/boss encounters/trigger events
-- all dependent on whether or not the player is inside of said zone (rectangle)

local zone = {
  x = 750,
  y = 475,
  w = 400,
  h = 100,
  spawnables = {
    {
      sBehaviours = {"run", "", ""},
      count = 0,
      max = 3,
      spawnTimer = 0,
      spawnTimerMax = .7
    }
  },
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

function addZone()
  -- local newZone = copy(zone, newZone)
  -- table.insert(zones, zone)
end

function updateZones(x, y, w, left, world, dt)
  if x + w > zone.x and x < zone.x + zone.w then

      for _, spawn in ipairs(zone.spawnables) do
        if spawn.count < spawn.max and spawn.spawnTimer <= 0 then
          spawn.spawnTimer = spawn.spawnTimerMax

          addEnemy({"run", "", ""}, left - 32, 511, world)
          spawn.count = spawn.count + 1
          print("created")
        end

        if spawn.spawnTimer > 0 then
          spawn.spawnTimer = spawn.spawnTimer - (1 * dt)
        end
      end

    end -- elseif player leaves the zone, reset spawn count and timer

  -- if the zone is no longer visible on the screen, then delete the zone?
end

function drawZones() -- zone's draw function should only be called when debug is true
  setColor(zone.color.inner)
  love.graphics.rectangle("fill", zone.x, zone.y, zone.w, zone.h)
  setColor(zone.color.outer)
  love.graphics.rectangle("line", zone.x, zone.y, zone.w, zone.h)
end
