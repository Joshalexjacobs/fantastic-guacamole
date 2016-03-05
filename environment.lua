-- environment.lua --

local function drawScanLines()
  local r, g, b, a = love.graphics.getColor()
  setColor(0, 0, 0, 15)

  local columnWidth = 800 / 200
  for x=1, 200 do
    love.graphics.line(x*columnWidth, 0, x*columnWidth, 800)
  end

  local rowHeight = 600 / 150
  for y=1, 150 do
    love.graphics.line(0, y*rowHeight, 600, y*rowHeight)
  end

  setColor(r, g, b, a)
end

function drawEnvironment()
  drawScanLines()
end
