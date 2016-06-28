-- start.lua --

require 'levels/levelsDictionary'

menu = {} -- previously: Gamestate.new()

dictionary = {}
indexPosition = 1

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
    love.graphics.rectangle("fill", 0, 13, 1920, 2)

    for i = 1, #dictionary do
      if i == indexPosition then
        love.graphics.setColor(255, 255, 0, 125)
        love.graphics.rectangle("fill", 0, i * 15, 1920, 15)
      end

      love.graphics.setColor(255, 255, 255, 250)
      love.graphics.print(dictionary[i].name, 10, i * 15)
    end

    love.graphics.print("Controls:\n WASD to move\n M to shoot\n N to jump", 100, 0)
    
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game, dictionary[indexPosition].name) -- switch to game and send select level name
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
    elseif key =='escape' then love.event.quit() end -- if player hits esc then quit
end
