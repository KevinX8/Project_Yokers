-----------------------------------------------------------------------------------------

-- movement.lua


-----------------------------------------------------------------------------------------

local function walkLeft(Sprite)
    Sprite:setLinearVelocity(-250, 0)
    Sprite.xScale = -1
end

local function walkRight(Sprite)
    Sprite:setLinearVelocity(250, 0)
    Sprite.xScale = 1
end

local function walkBackwards(Sprite)
    Sprite:setLinearVelocity(0, 250)
    Sprite.xScale = 1
end

local function walkForwards(Sprite)
    Sprite:setLinearVelocity(0, -250)
    Sprite.xScale = -1
end


local function walkLeft(event)
	local name = event.keyName.left
    local xv, yv = Sprite:getLinearVelocity()
  	if ((event.keyName.left == 's' or event.keyName.left == 'left') and event.phase == 'down' ) then
        walkLeft(Sprite)
    end
    
local function walkRight(event)  
	local name = event.keyName.right
  	if ((event.keyName.right == 'd' or event.keyName.right == 'right') and event.phase == 'down' ) then
        walkRight(Sprite)
    end
  	
local function walkBackwards(event)
	local name = event.keyName.backward
  	if ((event.keyName.backward == 's' or event.keyName.backward == 'backwards') and event.phase == 'down' ) then
        walkBackwards(Sprite)
    end
    
local function walkForwards(event)
	local name = event.keyName.forward 
    if ((event.keyName.forward == 'w' or event.keyName.forward == 'forwards') and event.phase == 'down' ) then
        walkForwards(Sprite)
    end

local function jump(Sprite)
    Sprite:setLinearVelocity(0, -150)
end

local function jump(event)
	local name = event.keyName.up
	if ((event.keyName.up == (keyBind.space()) or event.keyName.up == 'up') and event.phase == 'down' ) then
       jump(Sprite)
    end
end


