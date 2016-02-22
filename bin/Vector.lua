local class = require("libs.middleclass")

Vector = class("Vector")

function Vector:initialize(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Vector:addX(x, dt)
	delta = dt or 1
	self.x = self.x + x * (dt or 1)
	return self
end

function Vector:addY(y, dt)
	self.y = self.y + y * (dt or 1)
	-- self.y = self.y
	return self
end

function Vector:add(x, y, dt)
	return self:addX(x, dt):addY(y, dt)
end


function Vector:setX(x)
	self.x = x;
	return self
end


function Vector:setY(y)
	self.y = y;
	return self
end


function Vector:set(x, y)
	self:setX(x);
	self:setY(y);
	return self
end


function Vector:getX()
	return self.x
end


function Vector:getY()
	return self.y
end


function Vector:get()
	return self.x, self.y
end


function Vector:zero()
	return self:set(0, 0)
end


function Vector:scale(scalar)
	return self:set(self.x * scalar, self.y * scalar)
end


function Vector:round(precision)
	if (self:length() < precision) then self:zero() end
	return self
end


function Vector:length()
	return (self.x^2 + self.y^2)^0.5
end


function Vector:normalize()
	local len = self:length()
	local l = len == 0 and 1 or len
	
	self:set(self.x / l, self.y / l)
	return self
end


function Vector:cut(length)
	if self:length() > length then
		self:normalize():scale(length)
	end
	return self
end


function Vector:__add(other)
	return self:add(other:get())
end


function Vector:__tostring()
	return "Vector " .. tostring(self.x) .. " : " .. tostring(self.y)
end