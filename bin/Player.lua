require("Vector")
local class = require("libs.middleclass")

Player = class("Player")

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics
	

local RADIUS = 30
local SPEED = 350
local ACC = 500
local BRAKING = 5
local LASER_SPEED = 5

local speed = Vector:new()
local acc = Vector:new()

local firstLaserAngle
local secondLaserAngle


local function angleBetween(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end


function Player:initialize(x, y)
	local width, height = love.graphics.getDimensions()
	self.pos = Vector:new(x or width/2, y or height/2)
	firstLaserAngle = angleBetween(self.pos:getX(), self.pos:getY(), lm.getPosition())
	secondLaserAngle = firstLaserAngle - 180
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
	if (x > math.pi) then x = x - 2 * math.pi; return x
	elseif (x < -math.pi) then x = x + 2 * math.pi; return x
	else return x end
end


function Player:updateAngles(dt, mode)
	local pX, pY = self.pos:get()
	local mX, mY = lm.getPosition()
	local mouseAngle = angleBetween(pX, pY, mX, mY)

	if (sign(mouseAngle) ~= sign(firstLaserAngle)) then
		sgn = sign(-math.tan(firstLaserAngle))
		firstLaserAngle = roundAngle(firstLaserAngle + sgn * LASER_SPEED * dt)
	elseif (mouseAngle > firstLaserAngle) then
		firstLaserAngle = roundAngle(firstLaserAngle + LASER_SPEED * dt)
	else
		firstLaserAngle = roundAngle(firstLaserAngle - LASER_SPEED * dt)
	end


end


function Player:update(dt)
	self:move(dt)
	self:updateAngles(dt--[[   TODO   --]])
end


function Player:drawLaser(angle)
	local l = 200 -- replace it!
	local xStart, yStart = self.pos:get()
	local xEnd, yEnd = xStart + l * math.cos(angle), yStart + l * math.sin(angle)
	lg.line(xStart, yStart, xEnd, yEnd)
end


function Player:draw()
	lg.setColor(255, 255, 255)
	lg.circle("fill", self.pos:getX(), self.pos:getY(), RADIUS)
	lg.setColor(255, 50, 50)
	lg.circle("fill", self.pos:getX(), self.pos:getY(), 5)

	-- lg.line(self.pos:getX(), self.pos:getY(), love.mouse.getPosition())
	self:drawLaser(firstLaserAngle)
end
