


local lurker = require("libs.lurker")

function love.load()

end

function love.update(dt)
	lurker.update()


end

lg = love.graphics
function love.draw()
	lg.setBackgroundColor(0, 100, 100, 100)
	lg.circle("fill", 200, 200, 100)
	lg.setColor(200, 255, 255)
	lg.rectangle("fill", 100, 100, 100, 100)


end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end

end