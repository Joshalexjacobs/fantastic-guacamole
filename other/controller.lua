-- controller.lua --

noController = false

function loadController()
  local joysticks = love.joystick.getJoysticks()

  if joysticks[1] == nil then -- if no controller is found...
    noController = true -- set noController to true
    print("No controller was found.")
  else
    joystick = joysticks[1]
    print("Controller loaded.")
  end
end

function dPadLeft()
  if noController then
    return false
  else
    return joystick:isGamepadDown("dpleft")
  end
end

function dPadRight()
  if noController then
    return false
  else
    return joystick:isGamepadDown("dpright")
  end
end

function pressX()
  if noController then
    return false
  else
    return joystick:isGamepadDown("a")
  end
end

function pressCircle()
  if noController then
    return false
  else
    return joystick:isGamepadDown("b")
  end
end
