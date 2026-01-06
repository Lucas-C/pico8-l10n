local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
  require("lldebugger").start()

  function love.errorhandler(msg)
    error(msg, 2)
  end
end

-- Read product configuration
-- Shared between the game and CI
product_config = {}
for line in love.filesystem.lines("product.env") do
  -- Skip comment lines and blank lines
  if not (line:match("^%s*#") or line:match("^%s*$")) then
    local key, value = line:match("([^=]+)=(.*)")
    if key then
      product_config[key] = value:match('^"?(.-)"?$')
    end
  end
end

-- https://love2d.org/wiki/Config_Files
function love.conf(t)
  t.modules.audio = false              -- Enable the audio module (boolean)
  t.modules.data = false               -- Enable the data module (boolean)
  t.modules.event = false              -- Enable the event module (boolean)
  t.modules.font = false               -- Enable the font module (boolean)
  t.modules.graphics = false           -- Enable the graphics module (boolean)
  t.modules.image = false              -- Enable the image module (boolean)
  t.modules.joystick = false           -- Enable the joystick module (boolean)
  t.modules.keyboard = false           -- Enable the keyboard module (boolean)
  t.modules.math = false               -- Enable the math module (boolean)
  t.modules.mouse = false              -- Enable the mouse module (boolean)
  t.modules.physics = false            -- Enable the physics module (boolean)
  t.modules.sound = false              -- Enable the sound module (boolean)
  t.modules.system = false             -- Enable the system module (boolean)
  t.modules.thread = false             -- Enable the thread module (boolean)
  t.modules.timer = false              -- Enable the timer module (boolean)
  t.modules.touch = false              -- Enable the touch module (boolean)
  t.modules.video = false              -- Enable the video module (boolean)
  t.modules.window = false             -- Enable the window module (boolean)
end
