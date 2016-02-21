local class = require("libs.middleclass")

Vector = class("Vector")

function Vector:initialize(x, y)
	self.x = x or 0
	self.y = y or 0
end