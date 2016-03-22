-- require("Vector")
-- local class = require("libs.middleclass")
local shapes = require("libs.hc.shapes")


local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics

Actor = class("Actor")

-- local defHP = 10


function Actor:setShape(shape) self.shape = shape; return self end
function Actor:getShape() return self.shape end
function Actor:setDefaultShape() self.shape = nil end -- use only in initialization
function Actor:getHP() return hp end

function Actor:getX() return self.vPos:getX() end
function Actor:getY() return self.vPos:getY() end
function Actor:bbox() return self:getShape():bbox() end


Actor.default = {
	hp = 1,
	maxSpeed = 0,
	acc = 0,
	braking = 0,
}

function Actor:initDefault()
	for k, v in pairs(self.default) do
		self[k] = v
	end
end


function Actor:initialize(scene, x, y)
	local width, height = love.graphics.getDimensions()
	self:initDefault()

	self.vAcc = Vector()
	self.vSpeed = Vector()
	self.vPos = Vector:new(x or width/2, y or height/2)

	self:setDefaultShape(scene)
	scene:addActor(self)
end


function Actor:hit(damage, x, y)
	self.hp = self.hp - damage
	if (self.hp <= 0) then self:die() end
	self.hitX, self.hitY = x, y
end


function Actor:die()
	-- print(tostring(self) .. " on " .. self:getX(), self:getY() .. " died")
	drawer:shake(0.3)
	game:addSlowTime(0.1)
	self.died = true

	local sound = sfxr.newSound()
	sound:randomExplosion()
    local sounddata = sound:generateSoundData()
    local source = love.audio.newSource(sounddata)
    source:play()
end


function Actor:move(x, y)
	self.vPos:add(x, y)
end


function Actor:posUpdate(dt)
	self.vSpeed:add(self.vAcc:getX(), self.vAcc:getY(), dt)
	self.vSpeed:cut(self.maxSpeed)
	self.vPos:add(self.vSpeed:getX(), self.vSpeed:getY(), dt)
end


function Actor:updByShape()
	self.vPos:set(self:getShape():center())
end


function Actor:update(dt)
	self:posUpdate(dt)
	self.shape:moveTo(self.vPos:get())
end


function Actor:draw()
	if (self.hitX) then
		lg.setColor(255, 0, 0)
		lg.circle("fill", self.hitX, self.hitY, 10)
		self.hitX, self.hitY = nil, nil
	end
end