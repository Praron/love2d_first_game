-- require("Vector")
-- require("Enemy")
-- local class = require("libs.middleclass")
-- local shapes = require("libs.hc.shapes")

HiveChildEnemy = class("HiveChildEnemy", Enemy)

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics
local SIZE = 10


function HiveChildEnemy:initDefault()
	self.hp = 0.1
	self.maxSpeed = 100
	self.acc = 100
	self.braking = 10
end


function HiveChildEnemy:setDefaultShape(scene)
	local x, y = self:getX(), self:getY()
	self.shape = scene:rectangle(x, y, SIZE, SIZE)
end


local function angleBetween(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end


function HiveChildEnemy:posUpdate(dt)
	self:getShape():rotate(3 * dt)

	angle = angleBetween(self:getX(), self:getY(), self.vTarget:getX(), self.vTarget:getY())
	self.vSpeed:set(self.maxSpeed * math.cos(angle), self.maxSpeed * math.sin(angle))
	self.vPos:add(self.vSpeed:getX(), self.vSpeed:getY(), dt)
	self.shape:moveTo(self.vPos:get())
end


function HiveChildEnemy:draw()
	lg.setColor(255, 255, 255)
	self:getShape():draw("fill")
end