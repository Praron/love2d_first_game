
Game = class("Game")
Game:include(Stateful)

local menu = Game:addState("Menu")
local play = Game:addState("Play")
local pause = Game:addState("Pause")
local restart = Game:addState("Restart")

local player
local spawner
local scene

function Game:initialize()
	self:gotoState("Play")
end


function play:enteredState()
	scene = Scene:new()
	player = Player:new(scene)
	spawner = Spawner:new(scene, player.vPos)

	local px, py = player.vPos:get()

	spawner:circle(HiveChild, px, py, 350, 0.5, 3)
	spawner:circle(FatQueen, px, py, 300, 0, 6)
end


function restart:enteredState() -- maybe this causes memory leak, I don't know
	self:gotoState("Play")
end


function play:update(dt)
	-- if isPaused then dt = 0 end

	scene:update(dt)

	for laser = 1, 2 do
		local nearest
		local nearestDistance = -1
		local hitX, hitY
		local collisions = scene:collisions(player:getLaser(laser))
		for other, separating_vector in pairs(collisions) do
		    if not (other == player:getShape()) then
			    local enemy = scene:getActorByShape(other)
		    	if (nearestDistance == -1)
		    	or (player.vPos:dist2To(enemy.vPos) < nearestDistance)
		    	then
		    		nearest = enemy
		    		nearestDistance = player.vPos:dist2To(enemy.vPos)
		    		-- hitX and hitY works like random, you can repair it
				    hitX = nearest:getX() - separating_vector.x
				    hitY = nearest:getY() + separating_vector.y
		    	end

		    	if other:collidesWith(player:getShape()) then
		    		player:hit(10)
		    		enemy:die()
		    	end
			end
		end
		if nearest then nearest:hit(dt, hitX, hitY)
			player:setLaserLength(laser, hitX, hitY) end
	end
end


function pause:update(dt)
end


local function drawBackground()
	lg.setBackgroundColor(0, 100, 100)
	lg.setColor(0, 72, 72)
	local n = 12
	local w = W/n
	local h = H/n
	for x = 0, n do
		for y = 0, n do
			-- mr = math.random
			-- lg.setColor(mr(100), 72, 72)
			-- lg.rectangle("fill", x * w + mr(3), y * h + mr(3), w - mr(6), h - mr(6))
			lg.rectangle("fill", x * w + 3, y * h + 3, w - 6, h - 6)
		end
	end
end


local chroma = shine.separate_chroma()
chroma.radius = 3
chroma.angle = math.pi/4


function play:draw()
	chroma:draw(function()
		drawBackground()
		lg.setColor(255, 255, 255)
		scene:getCollider().hash:draw("line", false, false)
		scene:draw()

		local dcolor = 75
		lg.setColor(dcolor, dcolor, dcolor)
		lg.setBlendMode("subtract")
		for i = 0, W, 3 do
			lg.line(i, 0, i, H)
		end
		for i = 0, H, 3 do
		lg.line(0, i, W, i)
		end
		lg.setBlendMode("alpha")
	end)
end


function play:restart()
	self:gotoState("Restart")
end


function play:keypressed(key)
	if key == "p" then self:pushState("Pause") end
	if key == "r" then self:restart() end
	if key == "escape" then love.event.quit() end
	if key == "tab" then
		if player:getControlMode() == "mouse" then player:setControlMode("keyboard")
		else player:setControlMode("mouse") end
	end
end


function pause:keypressed(key)
	if key == "p" then self:popState() end
	if key == "r" then self:restart() end
	if key == "escape" then love.event.quit() end
	if key == "tab" then
		if player:getControlMode() == "mouse" then player:setControlMode("keyboard")
		else player:setControlMode("mouse") end
	end
end