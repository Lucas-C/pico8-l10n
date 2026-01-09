local io2 = require("io_utils")
local pico8 = require("pico8")

-- This will currently only work under Linux
-- It should easily be adapted to MacOS / Windows
local CART_DIR = os.getenv("HOME") .. "/.lexaloffle/pico-8/carts/"

local p8_png = {}

-- Return: p8_filepath, is_png
-- If is_png == true, a new file is created, and it's the caller responsibility to remove it in the end
function p8_png.with_png_converted(p8_or_png_filepath)
  if p8_or_png_filepath:match("%.p8$") then
    return p8_or_png_filepath, false
  elseif p8_or_png_filepath:match("%.p8%.png$") then
    return p8_png.png_to_p8(p8_or_png_filepath), true
  else
    error("Unsupported file extension: " .. p8_or_png_filepath)
  end
end

function p8_png.png_to_p8(p8_png_filepath)
  p8_png.ensure_pico8_is_available()
  p8_png.ensure_cart_dir_exists()
  local p8_png_filename = io2.basename(p8_png_filepath)
  local cart_filepath = CART_DIR .. p8_png_filename
  io2.copy(p8_png_filepath, cart_filepath)
  local p8_filepath = p8_png_filepath:sub(0, #p8_png_filepath - 4)
  local p8_filename = p8_png_filename:sub(0, #p8_png_filename - 4)
  local pico_code = ""
  pico_code = pico_code .. "load('" .. p8_png_filename .. "')\n"
  pico_code = pico_code .. "save('" .. p8_filename .. "')\n"
  pico8.exec(pico_code)
  assert(os.remove(cart_filepath))
  local ok, err = os.rename(CART_DIR .. p8_filename, p8_filepath)
  if not ok then
    error(p8_filename .. " was not created by PICO8 SAVE: " .. err)
  end
  return p8_filepath
end

function p8_png.p8_to_png(p8_filepath)
  p8_png.ensure_pico8_is_available()
  p8_png.ensure_cart_dir_exists()
  local p8_filename = io2.basename(p8_filepath)
  local cart_filepath = CART_DIR .. p8_filename
  io2.copy(p8_filepath, cart_filepath)
  local p8_png_filepath = p8_filepath .. ".png"
  local p8_png_filename = p8_filename .. ".png"
  local pico_code = ""
  pico_code = pico_code .. "load('" .. p8_filename .. "')\n"
  pico_code = pico_code .. "export('" .. p8_png_filename .. "')\n"
  pico8.exec(pico_code)
  assert(os.remove(cart_filepath))
  local ok, err = os.rename(cart_filepath .. ".png", p8_png_filepath)
  if not ok then
    error(p8_png_filename .. " was not created by PICO8 EXPORT: " .. err)
  end
  return p8_png_filepath
end

function p8_png.ensure_pico8_is_available()
  if not pico8.is_available() then
    error("The pico8 program could not be found in $PATH, but is required to handle .p8.png files")
  end
end

function p8_png.ensure_cart_dir_exists()
  if not io2.exists(CART_DIR) then
    error(CART_DIR .. " does not exist: either pico8 never initialized it, or this platform is currently not supported")
  end
end

return p8_png
