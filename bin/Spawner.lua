
Spawner = class("Spawner")

local tau = 2 * math.pi

function Spawner:initialize(scene, defaultTarget)
	self.scene = scene
	self.target = defaultTarget
end


function Spawner:setTarget(target)
	self.target = target
end


function Spawner:spawn(Enemy, x, y, target)
	local e = Enemy:new(self.scene, x, y)
	if target then e:setTarget(target) 
	else e:setTarget(self.target) end
	return e
end


function Spawner:spiralArc(Enemy, x, y, radius, deltaR, start, length, number)
	local rotation = length / (number)
	for angle = start, start + length - rotation, rotation do
	-- local rotation = length / (number - 1)
	-- for angle = start, start + length, rotation do
		if number == 1 then angle = (start + length) / 2 end -- small crutch

		self:spawn(Enemy, x + radius * math.cos(angle),
		           y + radius * math.sin(angle), target)
		radius = radius + deltaR
	end
end


function Spawner:arc(Enemy, x, y, radius, start, length, number)
	self:spiralArc(Enemy, x, y, radius, 0, start, length, number)
end


function Spawner:spiralCircle(Enemy, x, y, radius, deltaR, start, number)
	self:spiralArc(Enemy, x, y, radius, deltaR, start, tau, number)
end	


function Spawner:circle(Enemy, x, y, radius, start, number)
	self:arc(Enemy, x, y, radius, start, tau, number)
end
