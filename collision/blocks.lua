local blocks = {}

-- this function adds new blocks to our blocks table
function addBlock(x, y, w, h, world)
  local block = {x=x,y=y,w=w,h=h}
  blocks[#blocks+1] = block
  world:add(block, x,y,w,h)
end

-- this function draws every block inside of our blocks table
function drawBlocks()
  for _,block in ipairs(blocks) do
    love.graphics.rectangle("fill", block.x, block.y, block.w, block.h)
  end
end
