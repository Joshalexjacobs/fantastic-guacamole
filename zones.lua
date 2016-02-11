-- zones.lua --

-- zones indicate enemy spawns/item drops/boss encounters/trigger events
-- all dependent on whether or not the player is inside of said zone (rectangle)

zone = {
  x = 750,
  y = 475,
  w = 400,
  h = 100,
  color = {
    inner = {0, 250, 0, 20}, -- inner color
    outer = {0, 250, 0, 100} -- outer
  }
}

zones = {}

function addZone()
  -- table.insert(zones, zone)
end

function updateZones(x, y, w)
  if x + w > zone.x and x < zone.x + zone.w then
    print("he in")
  end
  -- if the zone is no longer visible on the screen, then delete the zone
end

function drawZones() -- zone's draw function should only be called when debug is true
  setColor(zone.color.inner)
  love.graphics.rectangle("fill", zone.x, zone.y, zone.w, zone.h)
  setColor(zone.color.outer)
  love.graphics.rectangle("line", zone.x, zone.y, zone.w, zone.h)
end
