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
	self.hp = 0.05
	self.maxSpeed = 150
	self.acc = 700
end


function HiveChildEnemy:setDefaultShape(scene)
	local x, y = self:getX(), self:getY()
	self.shape = scene:rectangle(x, y, SIZE, SIZE)
end


function HiveChildEnemy:posUpdate(dt)
	self:getShape():rotate(3 * dt)

	Enemy.posUpdate(self, dt)
end


function HiveChildEnemy:draw()
	lg.setColor(255, 255, 255)
	self:getShape():draw("fill")
	Actor.draw(self)
end