-- local lurker = require("libs.lurker")
class = require("libs.middleclass")
hc = require("libs.hc")
shapes = require("libs.hc.shapes")
inspect = require("libs.inspect")

require("Vector")
require("Actor")
require("Player")
require("Spawner")
require("Enemy")
require("Scene")
require("HiveChildEnemy")

local lk = love.keyboard
local lg = love.graphics

W = lg.getWidth()
H = lg.getHeight()

local player
local spawner
local scene

local isPaused = false



function love.load()

	scene = Scene:new()
	player = Player:new(scene)
	spawner = Spawner:new(scene, player.vPos)

	-- spawner:circle(HiveChildEnemy, player:getX(), player:getY(), 300, 0, 6)
	-- spawner:circle(HiveChildEnemy, player:getX(), player:getY(), 350, 0.5, 3)
	spawner:circle(HiveChildEnemy, player:getX(), player:getY(), 300, -1, 10)

end


function love.update(dt)
	if isPaused then dt = 0 end
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
		if nearest then nearest:hit(dt, hitX, hitY) end
	end
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


function love.draw()
	drawBackground()
	lg.setColor(255, 255, 255)
	scene:getCollider().hash:draw("line", false, false)
	scene:draw()

end


function love.keypressed(key)
	if key == "p" then isPaused = not isPaused end
	if key == "escape" then love.event.quit() end
	if key == "tab" then
		if player:getControlMode() == "mouse" then player:setControlMode("keyboard")
		else player:setControlMode("mouse") end
	end
end