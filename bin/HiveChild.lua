-- require("Vector")
-- require("Enemy")
-- local class = require("libs.middleclass")
-- local shapes = require("libs.hc.shapes")

HiveChild = class("HiveChild", Enemy)

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics
local SIZE = 15


HiveChild.default = {
	hp = 0.05,
	maxSpeed = 150,
	acc = 700,
}


function HiveChild:setDefaultShape(scene)
	local x, y = self:getX(), self:getY()
	self.shape = scene:rectangle(x, y, SIZE, SIZE)
end


function HiveChild:posUpdate(dt)
	self:getShape():rotate(3 * dt)

	Enemy.posUpdate(self, dt)
end


function HiveChild:draw()
	lg.setColor(255, 255, 255)
	self:getShape():draw("fill")
	Actor.draw(self)
end