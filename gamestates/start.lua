-- start.lua --

require 'levels/levelsDictionary'

menu = {} -- previously: Gamestate.new()

dictionary = {}
indexPosition = 1

resolutions = {
  strings = {
    "640 x 360", -- 1
    "960 x 540 -- Current", -- 2
    "1280 x 720", -- 3
    "1600 x 900", -- 4
    "1920 x 1080" -- 5
  },
  num = {
    {w = 640, h = 360, s = 2}, -- 1
    {w = 960, h = 540, s = 3}, -- 2
    {w = 1280, h = 720, s = 4}, -- 3
    {w = 1600, h = 900, s = 5}, -- 4
    {w = 1920, h = 1080, s = 6}, -- 5
  }
}



resIndex = 2

function menu:enter()
  dictionary = getDictionary()

  -- other
  loadController()
  love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})

end

function menu:update()
  -- empty for now
end

function menu:draw()
    love.graphics.print("Level", 10, 0)
    love.graphics.print("Controls:", 100, 0)
    love.graphics.print("<> Resolution:", 300, 0)
    
    love.graphics.rectangle("fill", 0, 14, 1920, 2)

    for i = 1, #dictionary do
      if i == indexPosition then
        love.graphics.setColor(255, 255, 0, 125)
        love.graphics.rectangle("fill", 0, i * 15, 1920, 15)
        love.graphics.setColor(255, 255, 255, 250)
        love.graphics.print(resolutions.strings[resIndex], 300, i * 15)
      end

      --love.graphics.setColor(255, 255, 255, 250)
      love.graphics.print(dictionary[i].name, 10, i * 15)
    end

    love.graphics.print("WASD to move", 100, 15)
    love.graphics.print("M to shoot", 100, 30)
    love.graphics.print("N to jump", 100, 45)
    love.graphics.print("ENTER to start", 100, 60)
    love.graphics.print("ESC to quit at any time", 100, 75)

end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game, dictionary[indexPosition].name, resolutions.num[resIndex]) -- switch to game and send select level name
    elseif key == 'down' or key == 's' then
        if indexPosition < #dictionary then
          indexPosition = indexPosition + 1
        elseif indexPosition == #dictionary then
          indexPosition = 1
        end
    elseif key == 'up' or key == 'w' then
        if indexPosition > 1 then
          indexPosition = indexPosition - 1
        elseif indexPosition == 1 then
          indexPosition = #dictionary
        end
    elseif key == 'right' or key == 'd' then
        if resIndex < #resolutions.strings then
          resIndex = resIndex + 1
        elseif resIndex == #resolutions.strings then
          resIndex = 1
        end
    elseif key == 'left' or key == 'a' then
        if resIndex > 1 then
            resIndex = resIndex - 1
        elseif resIndex == 1 then
          resIndex = #resolutions.strings
        end
    elseif key =='escape' then love.event.quit() end -- if player hits esc then quit
end
