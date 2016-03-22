
Input = class("Input")

t = tactile
function Input:initialize()
	self.buttons = {
	up		= t.newButton(t.key("w"), t.key("up")),
	down	= t.newButton(t.key("s"), t.key("down")),
	left	= t.newButton(t.key("a"), t.key("left")),
	right	= t.newButton(t.key("d"), t.key("right")),

	rotateLeft	= t.newButton(t.key("q"), t.key("k")),
	rotateRight	= t.newButton(t.key("e"), t.key("l")),

	slowTime	= t.newButton("space"),

	}

	self.axises = {
	horAxis		= t.binaryAxis(self.buttons.left, self.buttons.right),
	vertAxis	= t.binaryAxis(self.buttons.up, self.buttons.down),
	rotateSum	= t.binaryAxis(self.buttons.rotateLeft, self.buttons.rotateRight),

	}

end


function Input:isDown(key)
	return self.buttons[key]:isDown()
end


function Input:update()
	for _, v in self.buttons do
		v:update()
	end
end