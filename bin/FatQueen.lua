
FatQueen = class("FatQueen", Enemy)

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics
local RADIUS = 15


function FatQueen:initDefault()
	self.hp = 1
	self.maxSpeed = 80
	self.acc = 1000
end

function FatQueen:setDefaultShape(scene)
	local x, y = self:getX(), self:getY()
	self.shape = scene:circle(x, y, RADIUS)
end

function FatQueen:draw()
	lg.setColor(255, 255, 255)
	lg.circle("line", self:getX(), self:getY(), RADIUS)
	lg.circle("fill", self:getX(), self:getY(), RADIUS - 3)
	Enemy.draw(self)
end