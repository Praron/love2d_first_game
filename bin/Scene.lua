-- local class = require("libs.middleclass")
-- local hc = require("libs.hc")

Scene = class("Scene")


local collider = hc.new(love.graphics.getHeight()/4)
local actors = {}
local enemies = {}
local all = {[actors] = true, [enemies] = true}

function Scene:getCollider() return collider end

function Scene:rectangle(...) return collider:rectangle(...) end
function Scene:circle(...) return collider:circle(...) end
function Scene:collisions(...) return collider:collisions(...) end

function Scene:addActor(actor)
	actors[actor] = true
	-- collider:register(actor:getShape())
end


function Scene:getActorByShape(shape)
	for actor in pairs(actors) do
		if (actor:getShape() == shape) then return actor end
	end
end


function Scene:removeActor(actor)
	actors[actor] = nil
	collider:remove(actor:getShape())
end


function Scene:addEnemy(enemy)
	enemies[enemy] = true
	-- collider:register(enemy:getShape())
	-- collider:register(enemy)
	collider:registerActor(enemy)
end


function Scene:removeEnemy(enemy)
	enemies[enemy] = nil
	collider:remove(enemy:getShape())
end


function Scene:checkDied()
	for actor in pairs(actors) do
		if (actor.died) then self:removeActor(actor) end
	end
end


function Scene:update(dt)
	self:checkDied()
	for set in pairs(all) do
		for v in pairs(set) do
			v:update(dt);
		end
	end
end


function Scene:draw()
	for set in pairs(all) do
		for v in pairs(set) do
			v:draw();
		end
	end
end