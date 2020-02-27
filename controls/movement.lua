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
	local name = event.left
    local xv, yv = Sprite:getLinearVelocity()
  	if ((event.left == 's' or event.left == 'left') and event.phase == 'down' ) then
        walkLeft(Sprite)
    end
    
local function walkRight(event)  
	local name = event.right
  	if ((event.right == 'd' or event.right == 'right') and event.phase == 'down' ) then
        walkRight(Sprite)
    end
  	
local function walkBackwards(event)
	local name = event.backward
  	if ((event.backward == 's' or event.backward == 'backwards') and event.phase == 'down' ) then
        walkBackwards(Sprite)
    end
    
local function walkForwards(event)
	local name = event.forward 
    if ((event.forward == 'w' or event.forward == 'forwards') and event.phase == 'down' ) then
        walkForwards(Sprite)
    end

local function jump(Sprite)
    Sprite:setLinearVelocity(0, -150)
end

local function jump(event)
	local name = event.up
	if ((event.up == (keyBind.space()) or event.up == 'up') and event.phase == 'down' ) then
       jump(Sprite)
    end
end


