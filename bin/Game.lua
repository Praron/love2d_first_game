
Game = class("Game")
Game:include(Stateful)

local menu = Game:addState("Menu")
local play = Game:addState("Play")
local pause = Game:addState("Pause")
local restart = Game:addState("Restart")

local player
local spawner
local scene

function Game:initialize(settings)
	self.settings = settings or Settings:new()
	self:gotoState("Play")
end

function Game:getScene() return scene end


function play:enteredState()
	scene = Scene:new()
	player = Player:new(scene)
	spawner = Spawner:new(scene, player.vPos)

	local px, py = player.vPos:get()

	spawner:circle(Scout, px, py, 450, 0, 10)
	spawner:circle(HiveChild, px, py, 400, 0.5, 6)
	spawner:circle(FatQueen, px, py, 350, 0, 3)

	self.MAX_SLOW_TIME = 2
	self.SLOW_TIME_POWER = 2
	self.slowTime = self.MAX_SLOW_TIME

end


function restart:enteredState() -- maybe this causes memory leak, I don't know
	self:gotoState("Play")
end

function play:slowMotion(dt)
	if self.slowTime > 0 then
		self.slowTime = self.slowTime - dt
		return dt/self.SLOW_TIME_POWER
	else return dt end
end

function play:addSlowTime(time)
	self.slowTime = self.slowTime + time
	if self.slowTime > self.MAX_SLOW_TIME then
		self.slowTime = self.MAX_SLOW_TIME end
end


function play:update(dt)
	if lk.isDown("space") then dt = self:slowMotion(dt) end

	Timer.update(dt)
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

function play:restart(isPaused)
	self:gotoState("Restart")
	if isPaused then self:pushState("Pause") end
end

function play:keypressed(key)
	if key == "p" then self:pushState("Pause") end
	if key == "r" then self:restart(false) end
	if key == "escape" then love.event.quit() end
	if key == "tab" then
		if player:getControlMode() == "mouse" then player:setControlMode("keyboard")
		else player:setControlMode("mouse") end
	end
end

function pause:keypressed(key)
	if key == "p" then self:popState() end
	if key == "r" then self:restart(true) end
	if key == "escape" then love.event.quit() end
	if key == "tab" then
		if player:getControlMode() == "mouse" then player:setControlMode("keyboard")
		else player:setControlMode("mouse") end
	end
end