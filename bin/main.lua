-- local lurker = require("libs.lurker")
local class = require("libs.middleclass")
local hc = require("libs.hc")

require("Player")
require("Vector")

local lk = love.keyboard
local lg = love.graphics

local scene = hc.new(150)
local player

function scene:add(actor)
	scene:register(actor:getShape())
end

function love.load()
	player = Player:new()
	-- player:setShape(scene:circle(10, 10, 50))
	scene:add(player)






end


function love.update(dt)
	-- lurker.update()
	player:update(dt)
	-- print(player:getShape():center())
	


end

function love.draw()
	lg.setBackgroundColor(0, 100, 100)
	lg.setColor(0, 72, 72)
	local n = 12
	local W = lg.getWidth()
	local H = lg.getHeight()
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
	player:draw()



end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end

end