local blocks = {}

-- this function adds new blocks to our blocks table
function addBlock(xPos, yPos, width, height, world)
  local block = {name = "block", x = xPos, y = yPos, w = width, h = height}
  blocks[#blocks+1] = block
  world:add(block, block.x, block.y, block.w, block.h)
end

-- this function draws every block inside of our blocks table
function drawBlocks()
  for _,block in ipairs(blocks) do
    love.graphics.rectangle("fill", block.x, block.y, block.w, block.h)
  end
end
