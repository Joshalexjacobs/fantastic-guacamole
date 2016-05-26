-- water walker.lua --

waterWalker = {
  hp = 100,
  w = 96,
  h = 128,
  x = 2500,
  y = 40,
  dx = 0,
  dy = 0,
  speed = 0,
  spriteSheet = "",
  topAnim = nil,
  botAnim = nil,
  stage = 0, -- 0 entrance, 1, 2, 3 death
  isDead = false,
  -- doesnt need gravity
}

function waterWalker:load(world)
  print("loaded waterWalker")

  -- load spritesheet

  -- load animations

  -- add to world
end

function waterWalker:update(dt)
  -- once activated start entrance animation

  --  if stage 1...

  -- elseif stage 2...

  -- if dead then start death anim and death anim timer
  -- if death anim timer is finished end level
end

function waterWalker:draw()
  --love.graphics.print("waterWalker Active", 50, 0)
  love.graphics.rectangle("fill", waterWalker.x, waterWalker.y, waterWalker.w, waterWalker.h)
end
