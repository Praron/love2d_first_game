local class = require("libs.middleclass")

Player = class("Player")

local lk = love.keyboard
local lg = love.graphics
	
function Player:initialize(x, y)
	local width, height = love.graphics.getDimensions()
	self.x = x or width/2
	self.y = y or height/2
end

Player.speed = 100

function Player:addX(x)
	self.x = self.x + x
end

function Player:addY(y)
	self.y = self.y + y
end

function Player:update(dt)
	if lk.isDown("w") then self:addY(-self.speed * dt) end
	if lk.isDown("a") then self:addX(-self.speed * dt) end
	if lk.isDown("s") then self:addY(self.speed * dt) end
	if lk.isDown("d") then self:addX(self.speed * dt) end

end

function Player:draw()
	lg.circle("fill", self.x, self.y, 30)
end
