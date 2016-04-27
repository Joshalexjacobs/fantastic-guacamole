-- start.lua --

require 'levels/levelsDictionary'

menu = {} -- previously: Gamestate.new()

dictionary = {}
indexPosition = 1

function menu:enter()
  dictionary = getDictionary()
end

function menu:update()
  -- empty for now
end

function menu:draw()
    love.graphics.print("Level", 10, 0)
    love.graphics.rectangle("fill", 0, 13, 800, 2)

    for i = 1, #dictionary do
      if i == indexPosition then
        love.graphics.setColor(255, 255, 0, 125)
        love.graphics.rectangle("fill", 0, i * 15, 800, 15)
      end

      love.graphics.setColor(255, 255, 255, 250)
      love.graphics.print(dictionary[i].name, 10, i * 15)
    end
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game, dictionary[indexPosition].name) -- switch to game and send select level name
    end

    if key == 'down' or key == 's' then
        if indexPosition < #dictionary then
          indexPosition = indexPosition + 1
        elseif indexPosition == #dictionary then
          indexPosition = 1
        end
    end

    if key == 'up' or key == 'w' then
        if indexPosition > 1 then
          indexPosition = indexPosition - 1
        elseif indexPosition == 1 then
          indexPosition = #dictionary
        end
    end
end
