-- local lurker = require("libs.lurker")
class = require("libs.middleclass")
hc = require("libs.hc")
shapes = require("libs.hc.shapes")

require("Vector")
require("Actor")
require("Enemy")
require("Scene")
require("Player")
require("HiveChildEnemy")
-- require("Vector")

local lk = love.keyboard
local lg = love.graphics

W = lg.getWidth()
H = lg.getHeight()

local player

local scene = Scene:new()

function love.load()
	player = Player:new(scene)

	e = HiveChildEnemy:new(scene, 5, 5, 100, 100, 10)
	e:setTarget(player.vPos)
	e1 = HiveChildEnemy:new(scene, W-10, H-10, 100, 100, 10)
	e2 = HiveChildEnemy:new(scene, W, H, 100, 100, 10)
	e1:setTarget(player.vPos)
	e2:setTarget(player.vPos)

	for i = 0, 2 * math.pi, math.pi/6 do
		local d = 400
		local px, py = player:getX(), player:getY()
		local x, y = px + d * math.cos(i), py + d * math.sin(i)
		local en = HiveChildEnemy:new(scene, x, y, 100, 100, 10)
		en:setTarget(player.vPos)
	end

end


function love.update(dt)
	scene:update(dt)

	for laser = 1, 2 do
		local nearest
		local nearestDistance = -1
		local collisions = scene:collisions(player:getLaser(laser))
		for other, separating_vector in pairs(collisions) do
		    if not (other == player:getShape()) then
			    local enemy = scene:getActorByShape(other)
		    	if (nearestDistance == -1)
		    	or (player.vPos:dist2To(enemy.vPos) < nearestDistance)
		    	then
		    		nearest = enemy
		    		nearestDistance = player.vPos:dist2To(enemy.vPos)
		    	end
			    -- local x = enemy:getX() + separating_vector.x
			    -- local y = enemy:getY() + separating_vector.y
			    -- enemy:hit(dt)
			end
		end
		if nearest then nearest:hit(dt) end
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
	-- drawBackground()
	lg.setColor(255, 255, 255)
	scene:getCollider().hash:draw("line", false, true)
	player:getLaser(1)
	scene:draw()

end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "tab" then
		if player:getControlMode() == "mouse" then player:setControlMode("keyboard")
		else player:setControlMode("mouse") end
	end

end