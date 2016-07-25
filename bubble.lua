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
  speed = 30,
  dir = nil,
  isDead = false,
  filter = function(item, other)
    if other.type == "player" then
      return 'cross'
    elseif other.type == "block" or other.type == "ground" then
      return 'cross'
    end
  end,
  collision = function(entity, cols, len)
    for j = 1, len do
      if cols[j].other.type == "player" and entity.isDead == false then
        entity.isDead = true -- destroy bullet
        cols[j].other.killPlayer(world)
        break
      elseif cols[j].other.type == "block" or cols[j].other.type == "ground" then
        entity.isDead = true
        break
      end
    end
  end,
  curAnim = 1,
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

  newBubble.hp, newBubble.x, newBubble.y, newBubble.dir = health, xPos, yPos, direction
  addTimer(0.4, "spawn", newBubble.timers)

  world:add(newBubble, newBubble.x, newBubble.y, newBubble.w, newBubble.h) -- add all bubbles to world...
  table.insert(bubbles, newBubble) -- and the bubbles table
end

function updateBubbles(dt, world)
  for i, newBubble in ipairs(bubbles) do

    if updateTimer(dt, "spawn", newBubble.timers) and newBubble.isDead == false then
      newBubble.curAnim = 2
      newBubble.speed = 30
    else
      newBubble.speed = 150
    end

    if newBubble.isDead == false then
      newBubble.dy = math.sin(newBubble.dir) * newBubble.speed * dt
      newBubble.dy = newBubble.dy + (0.25 * math.sin(love.timer.getTime() * 4.1 * math.pi))
      newBubble.dx = math.cos(newBubble.dir) * newBubble.speed * dt
    end

    if newBubble.hp <= 0 then
      newBubble.isDead = true
    end

    if newBubble.isDead then
      newBubble.dx, newBubble.dy = 0, 0
      newBubble.curAnim = 3
      newBubble.type = "invincible"

      addTimer(1.0, "death", newBubble.timers)
    end

    if checkTimer("death", newBubble.timers) and updateTimer(dt, "death", newBubble.timers) and world:hasItem(newBubble) then
      world:remove(newBubble)
      table.remove(bubbles, i)
    end

    if world:hasItem(newBubble) then
      newBubble.x, newBubble.y, cols, len = world:move(newBubble, newBubble.x + newBubble.dx, newBubble.y + newBubble.dy, newBubble.filter) -- update world

      newBubble.collision(newBubble, cols, len)
    end

    newBubble.animations[newBubble.curAnim]:update(dt) -- update animations
  end
end

function drawBubbles()
  for _, newBubble in ipairs(bubbles) do
    newBubble.animations[newBubble.curAnim]:draw(newBubble.spriteSheet, newBubble.x + newBubble.offset.x, newBubble.y + newBubble.offset.y, 0, 1, 1, 10, newBubble.dir + 3)
    --love.graphics.rectangle("line", newBubble.x, newBubble.y, newBubble.w, newBubble.h)
  end
end
