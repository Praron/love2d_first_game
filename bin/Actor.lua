require("Vector")
local class = require("libs.middleclass")
local shapes = require("libs.hc.shapes")

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics

Actor = class("Actor")

Actor.maxSpeed = 0
Actor.acc = 0
Actor.braking = 0
Actor.vPos = Vector()
Actor.vSpeed = Vector()
Actor.vAcc = Vector()
Actor.shape = nil



function Actor:initialize(x, y, speed, acc, braking)
	local width, height = love.graphics.getDimensions()
	self.vPos = Vector:new(x or width/2, y or height/2)
	maxSpeed = speed or 0
	acc = acc or 0
	braking = braking or 0
	vSpeed = Vector:new()
	vAcc = Vector:new()
end


function Actor:move(dt)
	vSpeed:add(vAcc:getX(), vAcc:getY(), dt)
	vSpeed:cut(maxSpeed)
	self.vPos:add(vSpeed:getX(), vSpeed:getY(), dt)
end


function Actor:update(dt)
	self:move(dt)
end


function Actor:getX() return self.vPos:getX() end
function Actor:getY() return self.vPos:getY() end