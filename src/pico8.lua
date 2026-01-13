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

function pico8.cart_dir()
  local win_username = os.getenv("USERNAME")
  if win_username then
    return "C:/Users/" .. win_username .. "/AppData/Roaming/pico-8/carts/"
  end
  local OSTYPE = os.getenv("OSTYPE")
  if OSTYPE == "Darwin" then
    return os.getenv("HOME") .. "/Library/Application Support/pico-8/carts/"
  end
  return os.getenv("HOME") .. "/.lexaloffle/pico-8/carts/"
end

function pico8.ensure_cmd_is_available()
  if not pico8.is_available() then
    error("The pico8 program could not be found in $PATH, but is required to handle .p8.png files")
  end
end

function pico8.ensure_cart_dir_exists()
  if not io2.exists(pico8.cart_dir()) then
    error(
      pico8.cart_dir()
        .. " does not exist: either pico8 never initialized it, or this platform is currently not supported"
    )
  end
end

return pico8
