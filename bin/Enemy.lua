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
end
