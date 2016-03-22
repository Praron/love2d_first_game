
Drawer = class("Drawer")

function Drawer:addEffect(name, eff)
	self._effects[name] = eff
end

function Drawer:updateEffects()
	for k, v in pairs(self._effects) do
		self._effect = self._effect:chain(v)
	end
end

function Drawer:initialize(game)
	self._game = game
	self._effects = {}
	self._effect = shine.boxblur{radius = 0}

	self._canvas = love.graphics.newCanvas(W, H)
	-- self._canvas:setFilter("nearest", "nearest")

	self:addEffect("chroma", shine.separate_chroma
	               {radius = 3, angle = math.pi/4})
	self:updateEffects()

	self.isShaking = false
end


function Drawer:shake(time)
	self.isShaking = true
	chroma = self._effects.chroma
	chroma.radius = 3
	Timer.tween(time/2, chroma, {radius = 10}, "in-cubic",
		function() Timer.tween(time/2, chroma, {radius = 3}) end)
	Timer.after(time, function() chroma.radius = 3 -- sort of crutch, I don't know
	                             self.isShaking = false end)
end

function Drawer:_drawBackground()
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

	lg.setColor(255, 255, 255)
	game.getScene():getCollider().hash:draw("line", false, false)
end

function Drawer:_drawScene()
	lg.setColor(255, 255, 255)
	game.getScene():draw()


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
end

function Drawer:_drawSlowTimeBar()
	lg.setColor(255, 255, 255)
	local l = game.slowTime/game.MAX_SLOW_TIME * (W - 30)
	local w = 15
	local sx = 15
	local sy = H - 30
	if l > 0 then
		lg.rectangle("fill", sx, sy, l, w)
	end
end

function Drawer:_drawInterface()
	self:_drawSlowTimeBar()

end

function Drawer:draw()
	lg.setCanvas(self._canvas)
	lg.clear()

	self._effect:draw(function()
		self:_drawBackground()
		self:_drawScene()
		self:_drawInterface()
	end)

	lg.setCanvas()
	lg.setColor(255, 255, 255)

	local dx, dy
	if (self.isShaking) then
		local s = 10
		dx, dy = math.random(-s, s), math.random(-s, s)
	end
	lg.draw(self._canvas, dx, dy, 0, 1, 1)
end