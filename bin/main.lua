-- local lurker = require "libs.lurker"
class 	 = require "libs.middleclass"
Stateful = require "libs.stateful"
Timer	 = require "libs.timer"
hc 		 = require "libs.hc"
shapes	 = require "libs.hc.shapes"
inspect	 = require "libs.inspect"
shine	 = require "libs.shine"
-- tactile  = require "libs.tactile"
sfxr	 = require "libs.sfxr"

lk = love.keyboard
lg = love.graphics

W = lg.getWidth()
H = lg.getHeight()

require "Input"
require "Settings"

require "Vector"
require "Actor"
require "Player"
require "Spawner"
require "Enemy"
require "Scene"
require "HiveChild"
require "FatQueen"
require "Scout"

require("Game")
require("Drawer")


function love.load()
	game = Game:new()
	drawer = Drawer:new(game)
end


function love.update(dt)
	game:update(dt)
end


function love.draw()
	drawer:draw()
end


function love.keypressed(key) 
	game:keypressed(key)
end