-- water walker.lua --

waterWalker = {
  name = "waterWalker",
  type = "enemy",
  hp = 100,
  w = 75, -- 96
  h = 37,
  x = 2500,
  y = 35,
  dx = 0,
  dy = 0,
  speed = 50,
  image = "img/bosses/water walker.png",
  spriteSheet = nil,
  spriteGrid = nil,
  animations = {},
  curAnim = 1,
  stage = 0, -- 0 entrance, 1, 2, 3 death
  isDead = false,
  -- doesnt need gravity
}

function waterWalker:load(world)
  print("loaded waterWalker")

  -- load spritesheet
  waterWalker.spriteSheet = love.graphics.newImage(waterWalker.image)
  waterWalker.spriteGrid = anim8.newGrid(96, 128, 96, 128, 0, 0, 0)

  -- load animations
  waterWalker.animations = {                -- col, row
    anim8.newAnimation(waterWalker.spriteGrid(1, 1), 0.1), -- 1 idle
  }

  -- add to world
  world:add(waterWalker, waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)
end

function waterWalker:update(dt)
  -- once activated start entrance animation

  --  if stage 1...

  -- elseif stage 2...

  -- if dead then start death anim and death anim timer
  -- if death anim timer is finished end level

  waterWalker.animations[waterWalker.curAnim]:update(dt)
end

function waterWalker:draw()
  --love.graphics.rectangle("line", waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)

  waterWalker.animations[waterWalker.curAnim]:draw(waterWalker.spriteSheet, waterWalker.x, waterWalker.y, 0, 1, 1, 7, 15)
end
