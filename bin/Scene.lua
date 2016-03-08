-- local class = require("libs.middleclass")
-- local hc = require("libs.hc")

Scene = class("Scene")

function Scene:initialize()

	Scene.collider = hc.new(love.graphics.getHeight()/4)
	Scene.actors = {}
	Scene.enemies = {}
	Scene.all = {[Scene.actors] = true, [Scene.enemies] = true}

end

function Scene:getCollider() return self.collider end

function Scene:rectangle(...) return self.collider:rectangle(...) end
function Scene:circle(...) return self.collider:circle(...) end
function Scene:collisions(...) return self.collider:collisions(...) end


function Scene:addActor(actor)
	self.actors[actor] = true
	-- self.collider:register(actor:getShape())
end


function Scene:getActorByShape(shape)
	for actor in pairs(self.actors) do
		if (actor:getShape() == shape) then return actor end
	end
end


function Scene:removeActor(actor)
	self.actors[actor] = nil
	self.collider:remove(actor:getShape())
end


function Scene:addEnemy(enemy)
	self.enemies[enemy] = true
	-- self.collider:register(enemy:getShape())
	-- self.collider:register(enemy)
	self.collider:registerActor(enemy)
end


function Scene:removeEnemy(enemy)
	self.enemies[enemy] = nil
	self.collider:remove(enemy:getShape())
end


function Scene:checkDied()
	for actor in pairs(self.actors) do
		if (actor.died) then self:removeActor(actor) end
	end
end


function Scene:update(dt)
	self:checkDied()
	for set in pairs(self.all) do
		for v in pairs(set) do
			v:update(dt);
		end
	end
end


function Scene:draw()
	for set in pairs(self.all) do
		for v in pairs(set) do
			v:draw();
		end
	end
end