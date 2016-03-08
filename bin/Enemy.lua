-- require("Vector")
-- require("Actor")
-- local class = require("libs.middleclass")
-- local shapes = require("libs.hc.shapes")

Enemy = class("Enemy", Actor)

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics



function Enemy:setTarget(vTarget)
	self.vTarget = vTarget
	return self
end


local function angleBetween(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end


function Enemy:posUpdate(dt)
	self:getShape():rotate(3 * dt)

	angle = angleBetween(self:getX(), self:getY(), self.vTarget:getX(), self.vTarget:getY())
	self.vAcc:set(self.acc * math.cos(angle), self.acc * math.sin(angle))
	self.vSpeed:add(self.vAcc:getX(), self.vAcc:getY(), dt)
	self.vSpeed:cut(self.maxSpeed)
	self.vPos:add(self.vSpeed:getX(), self.vSpeed:getY(), dt)
	self.shape:moveTo(self.vPos:get())
end