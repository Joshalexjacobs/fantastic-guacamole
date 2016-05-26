-- zones.lua --

-- zones indicate enemy spawns/item drops/boss encounters/trigger events
-- all dependent on whether or not the player is inside of said zone (rectangle)

local zone = {
  name = "unnamed zone",
  x = 0,
  y = 0,
  w = 0,
  h = 0,
  active = false,
  spawnables = {},
  color = {
    inner = {0, 250, 0, 20}, -- inner color
    outer = {0, 250, 0, 100}, -- outer
    activated = {0, 255, 0, 50}
  }
}

zones = {}

function addZone(name, x, y, w, h, enemies)
  local newZone = copy(zone, newZone)
  newZone.name, newZone.x, newZone.y, newZone.w, newZone.h = name, x, y, w, h

  for i = 1, #enemies do -- add spawnable enemies to the zone
    newSpawn = enemies[i]

    table.insert(newZone.spawnables, newSpawn)
  end

  table.insert(zones, newZone)
end

function updateZones(x, w, left, world, dt)
  for _, newZone in ipairs(zones) do
    if x + w > newZone.x and x < newZone.x + newZone.w then

        if newZone.name == "boss zone" then
          bossFight = true
        end

        newZone.active = true

        for _, spawn in ipairs(newZone.spawnables) do
          if spawn.count < spawn.max and spawn.spawnTimer <= 0 then
            spawn.spawnTimer = spawn.spawnTimerMax

            if spawn.dynamic then
              addEnemy(spawn.name, player.x + spawn.x, spawn.y, spawn.side, world)
            else
              addEnemy(spawn.name, spawn.x, spawn.y, spawn.side, world)
            end

            spawn.count = spawn.count + 1
          end

          if spawn.spawnTimer > 0 then
            spawn.spawnTimer = spawn.spawnTimer - (1 * dt)
          end
        end

      else
        newZone.active = false
      end
    end
      -- if the zone is no longer visible on the screen, then delete the zone?...
end

function drawZones() -- zone's draw function should only be called when debug is true
  for _, newZone in ipairs(zones) do
    if newZone.active then setColor(newZone.color.activated)
    else setColor(newZone.color.inner) end

    love.graphics.rectangle("fill", newZone.x, newZone.y, newZone.w, newZone.h)
    setColor(newZone.color.outer)
    love.graphics.rectangle("line", newZone.x, newZone.y, newZone.w, newZone.h)

    -- print zone name
    setColor({255, 255, 255, 255})
    love.graphics.setFont(teenyFont)
    love.graphics.print(newZone.name, newZone.x + 1, newZone.y + 1)
    love.graphics.setFont(smallFont)
  end
end
