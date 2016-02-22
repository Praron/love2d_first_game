
require("Player")
require("Vector")


local lurker = require("libs.lurker")
local class = require("libs.middleclass")

local lk = love.keyboard
local lg = love.graphics

local player

function love.load()
	player = Player:new()




end

function love.update(dt)
	lurker.update()
	player:update(dt)
	


end

function love.draw()
	lg.setBackgroundColor(0, 100, 100)
	player:draw()



end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end

end