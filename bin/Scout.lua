
Scout = class("Scout", Enemy)

local lk = love.keyboard
local lm = love.mouse
local lg = love.graphics
local SIZE = 15


Scout.default = {
	hp = 0.1,
	maxSpeed = 250,
	acc = 10000,
}

function Scout:initialize(scene, x, y)
	Enemy.initialize(self, scene, x, y)
	self.rotateSign = math.random(1,2) == 1 and -1 or 1
	self.rotateSign = 1
end

function Scout:setTarget(vTarget)
	Enemy.setTarget(self, vTarget)
	self.realTarget = self.vTarget
	return self
end


function Scout:setDefaultShape(scene)
	local x, y = self:getX(), self:getY()
	local R = SIZE
	local a = R * math.sqrt(3)
	-- Trianlge
	local x1, y1 = x, y + R
	local x2, y2 = x - a/2, y - R/2
	local x3, y3 = x + a/2, y - R/2

	self.shape = scene:polygon(x1, y1, x2, y2, x3, y3)
end


local function angleBetween(x1, y1, x2, y2)
	return math.atan2((y2 - y1), (x2 - x1))
end


function Scout:posUpdate(dt)
	self:getShape():rotate(15 * dt)
	local dist = self.vPos:distTo(self.realTarget)
	local vDist = Vector:new(self.realTarget:getX()-self:getX(), self.realTarget:getY()-self:getY())
	vDist:rotate(self.rotateSign * 2)
	vDist:scale(1)
	self.vTarget = self.realTarget:copy():add(vDist:getX(), vDist:getY())

	Enemy.posUpdate(self, dt)
end

function Scout:draw()
	lg.setColor(255, 255, 255)
	self:getShape():draw("fill")
	Actor.draw(self)
end