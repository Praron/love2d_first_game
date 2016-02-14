function love.load()

end

function love.update(dt)


end

function love.draw()
	love.graphics.setColor(0, 100, 100)
	love.graphics.rectangle("fill", 100, 100, 100, 100)

end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end

end