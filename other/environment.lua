-- environment.lua --

function loadEnvironment()
   infoBox = love.graphics.newImage("img/background/infoBox.png")
   lives = love.graphics.newImage("img/background/assets/skull.png")
end

local function drawScanLines()
  local r, g, b, a = love.graphics.getColor()
  setColor(0, 0, 0, 15)

  local columnWidth = 800 / 200
  for x=1, 200 do
    love.graphics.line(x * columnWidth, 0, x * columnWidth, 800)
  end

  local rowHeight = 600 / 150
  for y=1, 150 do
    love.graphics.line(0, y * rowHeight, 800, y * rowHeight)
  end

  setColor(r, g, b, a)
end

local function drawInfoBox()
  local r, g, b, a = love.graphics.getColor()
  setColor(255, 255, 255, 255)

  love.graphics.draw(infoBox, 0, 525)

  for i = 1, player.lives do -- draw lives
    love.graphics.draw(lives, (40 * i) - 25, 530, 0, 2, 2, 0, 0)
    if i > 3 then break end
  end

  setColor(r, g, b, a)
end

function drawEnvironment()
  drawScanLines()
  drawInfoBox()
end
