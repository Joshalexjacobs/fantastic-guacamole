-- levelsDictionary.lua --

fairies = {}

local dictionary = {

  {
      name = "1-2",
      playerSkinV = "img/player/marine2BIG.png", -- vertical
      playerSkinH = "img/player/marineHorizontalBIG.png", -- horizontal
      tilemap = "tiled/New Level2.lua",
      startPos = 140, -- player's starting position
      bounds = { -- camera boundaries
        levelWidth = 1000, -- 8000
        levelHeight = 600,
        left = 0,
        top = 0
      },
      zones = {
        {
          name = "dynamic runners",
          x = 100,
          y = 45,
          w = 2000,
          h = 100,
          enemies = {
            {name = "runner", count = 0, max = 1000, side = "left", x = 200, y = 120, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
            {name = "runner", count = 0, max = 1000, side = "right", x = -200, y = 120, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
            --{name = "grenade", count = 0, max = 1000, side = "left", x = 400, y = 85, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
            {name = "grenade", count = 0, max = 1000, side = "right", x = 401, y = 85, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "prone-shooter", count = 0, max = 1, side = "right", x = 325, y = 160, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "laser-wall", count = 0, max = 1, side = "right", x = 150, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "wizard", count = 0, max = 1, side = "left", x = 500, y = 17, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2}, -- x = 190
            --{name = "wizard", count = 0, max = 1, side = "right", x = 550, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "gSlime", count = 0, max = 1, side = "left", x = 550, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "gSlime", count = 0, max = 1, side = "left", x = 380, y = 140, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "cSlime", count = 0, max = 1, side = "left", x = 380, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            {name = "cSlime", count = 0, max = 1, side = "left", x = 420, y = 0, dynamic = false, spawnTimer = 1, spawnTimerMax = 2.5},
            {name = "cSlime", count = 0, max = 1, side = "left", x = 460, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
          }
        },
      }, -- end of zones
      levelLoad = nil,
      levelUpdate = nil,
      levelDraw = nil
  }, -- end of level

  {
      name = "wall turret",
      playerSkinV = "img/player/marine2BIG.png", -- vertical
      playerSkinH = "img/player/marineHorizontalBIG.png", -- horizontal
      tilemap = "tiled/New Level2.lua",
      startPos = 740, -- player's starting position
      bounds = { -- camera boundaries
        levelWidth = 1000, -- 8000
        levelHeight = 600,
        left = 0,
        top = 0
      },
      zones = {
        {
          name = "wall turret",
          x = 100,
          y = 45,
          w = 2000,
          h = 100,
          enemies = {
            {name = "turret-wall", count = 0, max = 1, side = "right", x = 985, y = 5, dynamic = false, spawnTimer = 0, spawnTimerMax = 3}
          }
        },
      }, -- end of zones
      levelLoad = nil,
      levelUpdate = nil,
      levelDraw = nil
  }, -- end of level

  {
      name = "tutorial",
      playerSkinV = "img/player/matrix player.png", -- vertical
      playerSkinH = "img/player/matrix prone.png", -- horizontal
      tilemap = "tiled/matrix.lua",
      startPos = 140, -- player's starting position
      bounds = { -- camera boundaries
        levelWidth = 1000, -- 8000
        levelHeight = 600,
        left = 0,
        top = 0
      },
      zones = {
        {
          name = "empty",
          x = 100,
          y = 45,
          w = 2000,
          h = 100,
          enemies = {
            --{name = "turret-wall", count = 0, max = 1, side = "right", x = 985, y = 5, dynamic = false, spawnTimer = 0, spawnTimerMax = 3}
          }
        },
      }, -- end of zones

      -- level specific functions
      -- LEVEL LOAD --
      levelLoad = function()
        fairy = {
          x = nil,
          y = nil,
          w = nil,
          h = nil,
          dx = 0,
          dy = 0,
          speed = 10,
          range = 0,
          sinSpeed = 0,
          tails = {}
        }

        for i = 1, 35 do
          newFairy = copy(fairy, newFairy)

          newFairy.x = love.math.random(player.x - 200, player.x + 200)
          newFairy.y = love.math.random(0, 300)
          newFairy.w = 2
          newFairy.h = 2
          newFairy.range = love.math.random(7, 15) * 0.01
          newFairy.sinSpeed = love.math.random(1, 8) * 0.1

          for i = 1, love.math.random(1, 6) do
            tail = copy(newFairy, tail)
            tail.x = newFairy.x
            tail.y = newFairy.y + 2

            if i == 1 then
              tail.w = newFairy.w / 2
              tail.h = newFairy.w / 2
              tail.speed = newFairy.speed
            else
              tail.w = newFairy.tails[i-1].w / 2
              tail.h = newFairy.tails[i-1].w / 2
              tail.speed = newFairy.tails[i-1].speed - 1
            end

            table.insert(newFairy.tails, tail)
          end

          table.insert(fairies, newFairy)
        end
      end,

      -- LEVEL UPDATE --
      levelUpdate = function(dt)
        for _, newFairy in ipairs(fairies) do
          newFairy.dx = newFairy.range * math.cos(love.timer.getTime() * newFairy.sinSpeed * math.pi)
          newFairy.dy = -newFairy.speed * dt

          newFairy.x = newFairy.x + newFairy.dx
          newFairy.y = newFairy.y + newFairy.dy

          for _, tail in ipairs(newFairy.tails) do
            local direction = nil

            direction = math.atan2(newFairy.y - tail.y, newFairy.x - tail.x)

            tail.dx = math.cos(direction) * tail.speed * dt
            tail.dy = math.sin(direction) * tail.speed * dt

            tail.x = tail.x + tail.dx
            tail.y = tail.y + tail.dy
          end

          if newFairy.tails[#newFairy.tails].y < -2 then
            newFairy.x = love.math.random(player.x - 200, player.x + 200)
            newFairy.y = 200
            newFairy.range = love.math.random(7, 15) * 0.01
            newFairy.sinSpeed = love.math.random(1, 8) * 0.1

            for i, tail in ipairs(newFairy.tails) do
              tail.x = newFairy.x
              tail.y = newFairy.y + 2

              if i == 1 then
                tail.speed = newFairy.speed
              else
                tail.speed = newFairy.tails[i-1].speed - 1
              end
            end
          end
        end
      end,

      -- LEVEL DRAW --
      levelDraw = function()
        for _, newFairy in ipairs(fairies) do
          love.graphics.rectangle("fill", newFairy.x, newFairy.y, newFairy.w, newFairy.h, 1, 1)

          for _, tail in ipairs(newFairy.tails) do
            love.graphics.rectangle("fill", tail.x, tail.y, tail.w, tail.h, 1, 1)
          end
        end
      end

  }, -- end of level

} -- end of dictionary

function getLevel(levelName, level)
  for i = 1, #dictionary do
    if levelName == dictionary[i].name then
      level.name = dictionary[i].name
      level.bounds = dictionary[i].bounds
      level.zones = dictionary[i].zones

      -- player skins, location, and tilemap
      level.playerSkinV = dictionary[i].playerSkinV
      level.playerSkinH = dictionary[i].playerSkinH
      level.tilemap = dictionary[i].tilemap
      level.startPos = dictionary[i].startPos

      -- level functions
      level.levelLoad = dictionary[i].levelLoad
      level.levelUpdate = dictionary[i].levelUpdate
      level.levelDraw = dictionary[i].levelDraw
    end
  end
end

function getDictionary()
  return dictionary
end
