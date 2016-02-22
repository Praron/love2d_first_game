require("Vector")
local class = require("libs.middleclass")

Player = class("Player")

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics
	

local RADIUS = 20
local SPEED = 400
local ACC = 500
local BRAKING = 5
local LASER_SPEED = 5

local speed = Vector:new()
local acc = Vector:new()

local firstLaserAngle
local secondLaserAngle
local laserMode


local function angleBetween(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end


function Player:initialize(x, y)
	local width, height = love.graphics.getDimensions()
	self.pos = Vector:new(x or width/2, y or height/2)
	firstLaserAngle = angleBetween(self.pos:getX(), self.pos:getY(), lm.getPosition())
	secondLaserAngle = firstLaserAngle - math.pi
	laserMode = "direct"
end



function Player:move(dt)
	acc:zero()
	if lk.isDown("w") then acc:setY(-1) end
	if lk.isDown("a") then acc:setX(-1) end
	if lk.isDown("s") then acc:setY(1) end
	if lk.isDown("d") then acc:setX(1) end
	acc:normalize():scale(ACC)

	if not (lk.isDown("w")  or lk.isDown("a")
		or lk.isDown("s") or lk.isDown("d")) then
		speed:scale(1 - BRAKING * dt):round(1)
	end

	speed:add(acc:getX(), acc:getY(), dt)
	speed:cut(SPEED)
	self.pos:add(speed:getX(), speed:getY(), dt)
end


local function sign(x)
	return (x > 0 and 1 or x < 0 and -1 or 0)
end


local function roundAngle(x)
	while (math.abs(x) > math.pi) do
		x = x - sign(x) * 2 * math.pi
	end
	return x
end


function Player:setLaserMode(mode)
	laserMode = mode
	if ((mode ~= "direct") and (mode ~= "reverse") and (mode ~= "forced")) then
		error("wrong laser mode")
	end
end


function Player:updateLasers(dt)
	local pX, pY = self.pos:get()
	local mX, mY = lm.getPosition()
	local mouseAngle = angleBetween(pX, pY, mX, mY)

	local dAngle

	if lk.isDown("1") then self:setLaserMode("direct") end
	if lk.isDown("2") then self:setLaserMode("reverse") end
	if lk.isDown("3") then self:setLaserMode("forced") end
	love.window.setTitle(laserMode)


	if (math.abs(mouseAngle - firstLaserAngle) > 0.01) then -- for no dragging
		if (sign(mouseAngle) ~= sign(firstLaserAngle)) then
			sgn = sign(-math.tan(firstLaserAngle))
			dAngle = sgn * LASER_SPEED * dt
		elseif (mouseAngle > firstLaserAngle) then
			dAngle = LASER_SPEED * dt
		else
			dAngle = -LASER_SPEED * dt
		end

		firstLaserAngle = roundAngle(firstLaserAngle + dAngle)

		local slm
		if     (laserMode == "direrct") then slm = 1
		elseif (laserMode == "reverse") then slm = -1
		elseif (laserMode == "forced") then slm = 0
		else slm = 1; end
		secondLaserAngle = roundAngle(secondLaserAngle + slm * dAngle)

	end
end


function Player:update(dt)
	self:move(dt)
	self:updateLasers(dt)
end


function Player:drawLaser(angle, color)
	color = color or {0, 0, 0}
	local l = 1000 -- replace it!
	local xStart, yStart = self.pos:get()
	local xEnd, yEnd = xStart + l * math.cos(angle), yStart + l * math.sin(angle)
	lg.setColor(color[1], color[2], color[3])
	lg.line(xStart, yStart, xEnd, yEnd)
end


function Player:draw()
	lg.setColor(255, 255, 255)
	lg.circle("fill", self.pos:getX(), self.pos:getY(), RADIUS)
	lg.setColor(255, 50, 50)
	lg.circle("fill", self.pos:getX(), self.pos:getY(), 5)

	-- lg.line(self.pos:getX(), self.pos:getY(), love.mouse.getPosition())
	self:drawLaser(firstLaserAngle, {255, 0, 0})
	self:drawLaser(secondLaserAngle, {200, 200, 255})
end
