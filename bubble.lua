-- bubble.lua --

local bubble = {
  type = "bubble",
  hp = 1,
  x = nil,
  y = nil,
  w = 32,
  h = 32,
  dx = 0,
  dy = 0,
  offset = {x = 10, y = 2},
  speed = nil,
  dir = nil,
  isDead = false,
  filter = nil,
  collision = nil,
  curAnim = 2,
  spriteSheet = nil,
  spriteGrid = nil,
  animations = {},
  timers = {}
}

local bubbles = {}

function loadBubbles()
  bubble.spriteSheet = love.graphics.newImage("img/other/bubbleBIG.png")

  bubble.spriteGrid = anim8.newGrid(32, 32, 96, 192, 0, 0, 0)

  bubble.animations = {
    anim8.newAnimation(bubble.spriteGrid('1-3', 1, 1, 2), 0.1, "pauseAtEnd"), -- 1 spawn
    anim8.newAnimation(bubble.spriteGrid(1, 3), 0.1), -- 2 shot
    anim8.newAnimation(bubble.spriteGrid('1-3', '4-6', 2, 2), 0.1, "pauseAtEnd"), -- 3 dying
  }
end

function addBubble(health, xPos, yPos, direction, world)
  newBubble = copy(bubble, newBubble)

  newBubble.x, newBubble.y, newBubble.dir = xPos, yPos, direction
  addTimer(0.4, "spawn", newBubble.timers)

  world:add(newBubble, newBubble.x, newBubble.y, newBubble.w, newBubble.h) -- add all bubbles to world...
  table.insert(bubbles, newBubble) -- and the bubbles table
end

function updateBubbles(dt, world)
  for i, newBubble in ipairs(bubbles) do

    if newBubble.hp <= 0 and newBubble.isDead == false then
      newBubble.dx, newBubble.dy = 0, 0
      newBubble.isDead = true
      newBubble.curAnim = 3
      newBubble.type = "invincible"

      addTimer(1.0, "death", newBubble.timers)
    end

    if checkTimer("death", newBubble.timers) and updateTimer(dt, "death", newBubble.timers) and world:hasItem(newBubble) then
      world:remove(newBubble)
      table.remove(bubbles, i)
    end

    newBubble.animations[newBubble.curAnim]:update(dt) -- update animations
  end
end

function drawBubbles()
  for _, newBubble in ipairs(bubbles) do
    newBubble.animations[newBubble.curAnim]:draw(newBubble.spriteSheet, newBubble.x + newBubble.offset.x, newBubble.y + newBubble.offset.y, newBubble.dir, 1, 1, 10, newBubble.dir + 3)
    --love.graphics.rectangle("line", newBubble.x, newBubble.y, newBubble.w, newBubble.h)
  end
end
