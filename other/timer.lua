-- timer.lua --

timer = {
  time = nil,
  label = nil
}

function addTimer(startTime, name, timerList)
  local newTimer = copy(timer, newTimer)
  newTimer.time, newTimer.label = startTime, name

  table.insert(timerList, newTimer)

  -- return newTimer
end

local function findTimer(name, timerList)
  for i = 1, #timerList do
    if timerList[i].label == name then return i end
  end
end

function updateTimer(dt, name, timerList) -- update all existing timers
  -- if #timerList == 0 return false end -- if timerList does not contain a timer
  index = findTimer(name, timerList)
  if timerList[index].time <= 0 then
    table.remove(timerList, i)
    return true
  elseif timerList[index].time > 0 then
    timerList[index].time = timerList[index].time - dt
    return false
  end
end

--[[for i = 1, #timers do
   if timers[i].time > 0 then
     timers[i].time = timers[i] - dt
   end

   if timers[i].time <= 0 then
     table.remove(timers, i) -- if a timer has ended, remove it from timers
     -- return
   end
end]]

-- a few ways to do this...
-- 1. pass the whole timer list and then a label, if label is nil increment all, if not increment only label
-- 2. pass only 1 timer at a timer and no label...get rid of label entirely
-- 3. each enemy/entity has their own timer list and the timer class just helps each object manage them:
-- - addTimer(startTime, label, timerList) function -- creates and adds a newtimer to timerList
-- - update(label) function -- returns true if timer is finished or false if it's still going
-- - etc...
