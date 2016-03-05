local blocks = {}

function loadBlocks()
  -- create randomly generated floating blocks, pillars in the foreground (in front of player), stars, stalagtites, and stalagmites
end

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
    setCFluxShade()
    --setColor(255, 255, 255)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", block.x, block.y, block.w, block.h)
  end
end
