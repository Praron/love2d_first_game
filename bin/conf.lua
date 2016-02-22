function love.conf(t)
    t.title = "Game"
    t.author = "Praron"
    t.identity = "data"
    t.version = "0.10.0"
    t.console = false

    t.window.icon = nil
    t.window.minwidth = 512
    t.window.minheight = 512 
    t.window.resizable = false
    t.window.width = 750
    t.window.height = 612
    t.window.fullscreen = false
    t.window.vsync = false
    t.window.fsaa = 0

    t.modules.joystick = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.audio = true
    t.modules.sound = true  
    t.modules.keyboard = true
    t.modules.mouse = true
    t.modules.event = true
    t.modules.timer = true
    t.modules.physics = true
    io.stdout:setvbuf("no")
end