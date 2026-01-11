local io2 = require("io_utils")

local pico8 = {}

local IS_PICO_IN_PATH = nil -- cache to avoid repeated useless calls to io.popen

-- Check if a program named `pico8` is in $PATH and is able to evaluate Lua code:
function pico8.is_available()
  if IS_PICO_IN_PATH == nil then
    if pcall(pico8.exec) then
      IS_PICO_IN_PATH = true
    else
      IS_PICO_IN_PATH = false
    end
  end
  return IS_PICO_IN_PATH
end

function pico8.exec(lua_code)
  local tmp_filename = os.tmpname()
  io2.create_file(tmp_filename, "pico-8 cartridge\nversion 43\n__lua__\n" .. (lua_code or ""))
  local output = io2.run("pico8 -x " .. tmp_filename)
  assert(os.remove(tmp_filename))
  return output
end

return pico8
