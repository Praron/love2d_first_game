require("Vector")
local class = require("libs.middleclass")
require("Actor")

Player = class("Player", Actor)

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics
	

local RADIUS = 20

local LASER_SPEED = 5
local LASER_LENGTH = 1000
local KEYBOARD_ROTATE_SPEED = 5

local bounds

local firstLaserAngle
local secondLaserAngle
local laserMode

local controlMode

local maxSpeed = 400
local acc = 500
local braking = 5



local function angleBetween(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end


function Player:initialize(x, y)
	Actor.initialize(self, x, y, maxSpeed, acc, braking)


	firstLaserAngle = 0.01  -- that's weird but lasers are not rotating by keyboard if = 0
	secondLaserAngle = firstLaserAngle - math.pi
	controlMode = "mouse"
	laserMode = "direct"

	bounds = {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()}
end


local function pointInBounds(x, y, bounds)
	if (x > bounds.x and x < (bounds.x + bounds.w))
	   and (y > bounds.y and y < (bounds.y + bounds.h)) then
	   return true
	else
		return false
	end
end


function clamp(low, n, high) return math.min(math.max(low, n), high) end


function Player:handleWASD(dt)
	vAcc:zero()
	if lk.isDown("w") or lk.isDown("up") then vAcc:addY(-1) end
	if lk.isDown("a") or lk.isDown("left") then vAcc:addX(-1) end
	if lk.isDown("s") or lk.isDown("down") then vAcc:addY(1) end
	if lk.isDown("d") or lk.isDown("right") then vAcc:addX(1) end
	vAcc:normalize():scale(acc)

	if not (lk.isDown("w")  or lk.isDown("a")
		or lk.isDown("s") or lk.isDown("d")
		or lk.isDown("up")  or lk.isDown("left")
		or lk.isDown("down") or lk.isDown("right")) then
		vSpeed:scale(1 - braking * dt):round(1)
	end
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
	local pX, pY = self.vPos:get()
	local mX, mY = lm.getPosition()
	local mouseAngle = firstLaserAngle

	if (controlMode == "mouse") then
		mouseAngle = angleBetween(pX, pY, mX, mY)
	else
		if (lk.isDown("q")) then mouseAngle = firstLaserAngle - KEYBOARD_ROTATE_maxSpeed * dt end
		if (lk.isDown("e")) then mouseAngle = firstLaserAngle + KEYBOARD_ROTATE_maxSpeed * dt end
	end

	local dAngle

	if lk.isDown("1") then self:setLaserMode("direct") end
	if lk.isDown("2") then self:setLaserMode("reverse") end
	if lk.isDown("3") then self:setLaserMode("forced") end

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


function Player:getLaser(number)
	local laser
	local l = LASER_LENGTH
	if number == 1 then laser = firstLaserAngle end
	if number == 2 then laser = secondLaserAngle end
	local xs, ys = self.vPos:getX(), self.vPos:getY()
	local xe, ye = xs + l * math.cos(laser), ys + l * math.sin(laser)

	return {xs = xs, ys = ys, xe = xe, ye = ye}
end


function Player:drawLaser(number, color)
	color = color or {0, 0, 0}
	laser = self:getLaser(number)
	local xStart, yStart = laser.xs, laser.ys
	local xEnd, yEnd = laser.xe, laser.ye
	lg.setColor(color[1], color[2], color[3])
	lg.line(xStart, yStart, xEnd, yEnd)
end


function Player:update(dt)
	self:handleWASD(dt)
	Actor.update(self, dt)
	self:updateLasers(dt)

	if not pointInBounds(self.vPos:getX(), self.vPos:getY(), bounds) then
		self.vPos:add(-vSpeed:getX(), -vSpeed:getY(), dt)
		vSpeed:zero()
	end
end


function Player:draw()
	lg.setColor(150, 100, 100)
	lg.circle("fill", self:getX(), self:getY(), RADIUS + 3)
	lg.setColor(255, 255, 255)
	lg.circle("fill", self:getX(), self:getY(), RADIUS)
	lg.setColor(250, 50, 100)
	lg.circle("fill", self:getX(), self:getY(), 12)
	lg.setColor(220, 200, 200)
	lg.circle("fill", self:getX(), self:getY(), 10)
	lg.setColor(255, 50, 150)
	lg.circle("fill", self:getX(), self:getY(), 5)

	self:drawLaser(1, {255, 0, 0})
	self:drawLaser(2, {200, 200, 255})
end
