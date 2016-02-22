function love.conf(t)
    -- основные настройки
    t.title = "Game"          -- заголовок окна и название игры
    t.author = "Praron"         -- автор игры
    t.identity = "data"       -- папка, куда игра сможет писать
    t.version = "0.10.0"     -- версия фреймворка
    t.console = false           -- консоль (исп-ся только для Windows-сборки)
    -- настройки окна
    t.window.icon = nil             -- путь к иконке для окна
    t.window.minwidth = 512     -- мин. длина окна, если можно менять его размер мышью
    t.window.minheight = 512        -- мин. высота окна
    t.window.resizable = false  -- можно ли пользователю менять размер окна мышкой?
    t.window.width = 720        -- начальная длина окна (любое число, большее минимального)
    t.window.height = 512       -- начальная высота окна
    t.window.fullscreen = false -- на весь экран?
    t.window.vsync = false      -- вкл. вертикальную синхронизацию? (я ее отключаю, т. к. у меня картинка подлагивает)
    t.window.fsaa = 0           -- экранное сглаживание (anti-aliasing)
    -- модули
    t.modules.joystick = true   -- поддержка джойстика
    t.modules.graphics = true   -- загрузка и рисование графики
    t.modules.image = true      -- процедурное создание графики и сохранение в файл
    t.modules.audio = true      -- воспроизведение звуков и музыки
    t.modules.sound = true      -- процедурное создание звуков и сохранение в файл
    t.modules.keyboard = true   -- клавиатура
    t.modules.mouse = true      -- мышь
    t.modules.event = true      -- создание и обработка событий
    t.modules.timer = true      -- таймер (иначе love.update не будет работать)
    t.modules.physics = true        -- встроенная физика Box2D
    io.stdout:setvbuf("no")     -- чтобы работала консоль в Sublime Text
end