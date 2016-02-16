-- CFlux.lua 0.21--

version = 0.21

cflux = {
  red = 0,
  green = 0,
  blue = 0,
  alpha = 255,
  rDir = 0,
  gDir = 0,
  bDir = 0
}

function cfluxVer()
  return "\nCFlux.lua - ", version -- returns the current version number
end

function setColor(r, g, b, a)
  love.graphics.setColor(r, g, b, a)
end

function setAlpha(a)
  cflux.alpha = a
  love.graphics.setColor(cflux.red, cflux.green, cflux.blue, cflux.alpha)
end

function setCFluxColor()
  love.graphics.setColor(cflux.red, cflux.green, cflux.blue, cflux.alpha)
end

function generateRandomColor(dir)
  newDir = dir

  while newDir == dir do -- loop to ensure that newDir is not the same as the previous one
    newDir = love.math.random(0, 255)
  end

  return newDir
end

function updateColor(color, dir)
  if color == dir then
    dir = generateRandomColor(dir)
  elseif color > dir then
    color = color - 1
  elseif color < dir then
    color = color + 1
  end

  return color, dir
end

function updateCFlux()
  cflux.red, cflux.rDir = updateColor(cflux.red, cflux.rDir)
  cflux.green, cflux.gDir = updateColor(cflux.green, cflux.gDir)
  cflux.blue, cflux.bDir = updateColor(cflux.blue, cflux.bDir)
  -- update alpha?
end
