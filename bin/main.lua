-- local lurker = require("libs.lurker")
class = require("libs.middleclass")
hc = require("libs.hc")
shapes = require("libs.hc.shapes")
inspect = require("libs.inspect")
shine = require("libs.shine")
Stateful = require("libs.stateful")

require("Vector")
require("Actor")
require("Player")
require("Spawner")
require("Enemy")
require("Scene")
require("HiveChild")
require("FatQueen")


lk = love.keyboard
lg = love.graphics

W = lg.getWidth()
H = lg.getHeight()

require("Game")

local isPaused = false

local game

function love.load()
	game = Game:new()
end


function love.update(dt)
	game:update(dt)
end


function love.draw()
	game:draw()
end


function love.keypressed(key)
	game:keypressed(key)
end